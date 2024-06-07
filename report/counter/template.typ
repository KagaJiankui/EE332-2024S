#let text_base_size = 10pt
#let text_h1_size = 22pt
#let header_size_increment = 4pt
#let heading_q = 1.18

#let question_counter = counter("question_counter")
#let part_counter = counter("part_counter")
#let disp_question_counter = false

#let emp_block(body, fill: luma(230), stroke: orange) = {
  block(
    width: 100%,
    fill: fill,
    inset: 8pt,
    radius: 0pt,
    stroke: (left: (stroke + 3pt), right: (luma(200) + 3pt)),
    body,
  )
}

#let booktab(sp: text_base_size) = {
  v(5pt, weak: true)
  block(
    width: 100%,
    [
      #line(length: 100%, stroke: 3pt + luma(140))
      #move(line(length: 100%), dx: 0pt, dy: sp)
    ],
  )
  v(0pt, weak: true)
}

#let heading_number_list=("I.","A.","1.")

#let project(title: "", authors: (), show_info: true, body) = {
  set page(
    paper: "a4",
    numbering: "1",
    margin: (x: 20mm, y: 12.7mm),
  )
  set par(justify: true)
  set text(
    font: ("New Computer Modern", "SimSun"),
    size: text_base_size,
    lang: "zh",
  )
  set math.equation(numbering: "(1)", supplement: text(font: "Linux Biolinum")[Eq.])
  set list(marker: ([▪], [▹]))

  set heading(numbering:"I.A.1")

  show heading: it => {
    let heading_size = text_h1_size * calc.pow(heading_q, -1 * it.level)
    // let heading_size = text_base_size
    let hdg_maxlevel = int(calc.log(text_h1_size / text_base_size, base: heading_q)) + 1
    let hdg_sublevel = 0
    heading_size=int(heading_size/1pt)*1pt
    if heading_size <= text_base_size {
      heading_size = text_base_size
      hdg_sublevel = it.level - hdg_maxlevel
    }
    block(width: 100%)[
      #{
        set text(size: heading_size)
        if (it.level <= hdg_maxlevel) {
          if it.level==1 {
            numbering("I.",counter(heading).get().at(0))
          } else if it.level==2 {
            numbering("I.A.",counter(heading).get().at(0),counter(heading).get().at(1))
          } else if it.level==3 {
            numbering("I.A.1.",counter(heading).get().at(0),counter(heading).get().at(1),counter(heading).get().at(2))
          }
          strong(it.body)
        } else {
          emph(it.body)
        }
      }
    ]
    // context counter(heading).get()
    let sp_true = -1*heading_size+1pt
    booktab(sp: sp_true)
  }

  show outline.entry.where(level: 2): it => {
    v(8pt, weak: true)
    strong(it)
  }

  show link: it => [
    #underline(text(rgb("#4466ff"))[#it.body], stroke: (dash: "dashed"))
  ]

  show raw: text.with(font: "Sarasa Fixed SC Nerd Font")

  if show_info {
    // Title row.
    align(center)[
      #strong()[
        #text(size: {heading_q*text_h1_size})[
          #title
        ]
      ]
    ]

    // Author information.
    pad(
      top: 0em,
      bottom: 0em,
      x: 2em,
      grid(
        columns: (1fr,) * calc.min(3, authors.len()),
        gutter: 1em,
        ..authors.map(elem => align(
          center,
          [
            #elem.at("name_cn") / #elem.at("name_en") \
            #emph(elem.at("affiliation")) \
            #elem.at("contact")
          ],
        )),
      ),
    )
  }

  // Main body.
  set par(justify: true)

  body
}