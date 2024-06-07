from io import BytesIO
import os
import threading
import fitz
import numpy as np  # PyMuPDF
from PIL import Image


def crop_image_to_content(image_bytes, margin=5, white_threshold=240):
  """使用优化方法裁剪图像，去除接近白色的边缘。"""
  # 将字节数据转换为numpy数组
  img = np.asarray(Image.open(BytesIO(image_bytes)))

  # 判断像素是否接近白色（所有通道的值都大于阈值）
  is_not_white = np.all(img < white_threshold, axis=-1)

  # 确定非白色内容的边界
  rows = np.any(is_not_white, axis=1)
  cols = np.any(is_not_white, axis=0)

  if not rows.any() or not cols.any():  # 如果整个图像都是白色的，返回原图
    return img

  x, xx = np.where(rows)[0][[0, -1]]
  y, yy = np.where(cols)[0][[0, -1]]

  # 考虑边界margin
  x = max(x - margin, 0)
  xx = min(xx + margin + 1, img.shape[0])
  y = max(y - margin, 0)
  yy = min(yy + margin + 1, img.shape[1])

  # 裁剪图像
  cropped_img = img[x:xx, y:yy]

  return cropped_img


def convert_pdf_to_png(pdf_file):
  try:
    # 打开 PDF 文件
    pdf_document = fitz.open(pdf_file)
    page = pdf_document[0]  # 假设单页 PDF

    # 获取基本文件名（不包含扩展名）
    base_filename = os.path.splitext(pdf_file)[0]

    # 将页面转换为 PNG
    image = page.get_pixmap(matrix=fitz.Matrix(2, 2))  # 提高分辨率以获得更好的质量
    image_png = image.tobytes(output="png")
    cutted_res = crop_image_to_content(image_png, margin=10, white_threshold=240)
    cutted_res = Image.fromarray(cutted_res)
    cutted_res.save(f"{base_filename}.png", format="png")
    image = None
    print(f"已将 {pdf_file} 转换为 {base_filename}.png")
  except Exception as e:
    print(f"转换 {pdf_file} 时出错：{e}")


def main():
  # 获取当前目录中的 PDF 文件列表
  pdf_files = [file for file in os.listdir() if file.lower().endswith(".pdf")]

  # 为每个 PDF 文件创建一个线程
  threads = []
  for pdf_file in pdf_files:
    thread = threading.Thread(target=convert_pdf_to_png, args=(pdf_file,))
    threads.append(thread)
    thread.start()

  # 等待所有线程完成
  for thread in threads:
    thread.join()


if __name__ == "__main__":
  main()
