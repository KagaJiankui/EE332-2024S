import os
import threading
import fitz  # PyMuPDF

# Function to rotate a PDF page to 0 degrees
def rotate_pdf_page(pdf_file):
  try:
    # Open the PDF file
    pdf_document = fitz.open(pdf_file)
    page = pdf_document[0]  # Assuming only one page in the PDF

    # Get the current rotation angle
    current_rotation = page.rotation

    # If the current rotation is not 0, rotate the page to 0 degrees
    if current_rotation != 0:
      page.set_rotation(0)
      new_pdf_file = pdf_file.replace(".pdf", "_1.pdf")
      pdf_document.save(new_pdf_file, garbage=4, deflate=True)
      print(f"{pdf_file} Rotation OK. Saved as {new_pdf_file}.")
      pdf_document.close()
    else:
      print(f"No rotation needed for {pdf_file}.")

  except Exception as e:
    print(f"Error rotating page in {pdf_file}: {str(e)}")

# Get a list of all PDF files in the current directory
pdf_files = [file for file in os.listdir() if file.lower().endswith(".pdf")]

# Create a thread for each PDF file
threads = []
for pdf_file in pdf_files:
  thread = threading.Thread(target=rotate_pdf_page, args=(pdf_file,))
  threads.append(thread)
  thread.start()

# Wait for all threads to finish
for thread in threads:
  thread.join()