#let song = ("Times New Roman", "SimSun")
#let san = 16pt
#let xiaosan = 15pt
#let si = 14pt
#let xiaosi = 12pt

// 中文缩进
#let indent = h(2em)

// 假段落，附着于 heading 之后可以实现首行缩进
#let empty-par = par[#box()]
#let fake-par = context empty-par + v(-measure(empty-par + empty-par).height)

#let cover(
  info: (:),
  ..args
) = {
  let info = info + args.named()
  let info-key(body) = {
      align(body, right + horizon)
  }

  let info-value(body) = {
    block(
      height: 23pt,
      width:100%,
      stroke: (bottom: 0.5pt),
      align(body, center + horizon)
    )
  }

  set align(center)
  set text(font: song, size: si)
  
  pagebreak(weak: true)

  v(60pt)
  image("logo.svg", width: 50%)
  v(20pt)
  text(font: "Source Han Serif SC", size: san)[本科实验报告]
  v(50pt)
  grid(
    inset:0pt,
    columns: (75pt, 300pt),
    row-gutter: 13pt,
    info-key("课程名称："), info-value(info.course),
    info-key("姓       名："), info-value(info.name),
    info-key("学       院："), info-value(info.college),
    info-key("系："), info-value(info.department),
    info-key("专       业："), info-value(info.major),
    info-key("学       号："), info-value(info.id),
    info-key("指导教师："), info-value(info.advisor),
  )
  v(50pt)
  info.date

  pagebreak(weak: true)

}

#let report-title(
  info: (:),
  ..args
) = {
  let info = info + args.named()
  pagebreak(weak: true)
  let info-key(body) = {
      align(body, center + horizon)
  }

  let info-value(body) = {
    block(
      width: 100%,
      height: 18pt,
      stroke: (bottom: 1pt),
      align(body, center + horizon)
    )
  }

  set align(center)
  set text(font: song, size: xiaosi,)

  text(font: "Source Han Serif SC", size: xiaosan, weight: "bold")[浙江大学实验报告]
  v(15pt)
  grid(
    row-gutter: 3pt,
    grid(
      columns: (1fr, 50%, 1fr, 21%),
      info-key("课程名称："), info-value(info.course),
      info-key("实验类型："), info-value(info.type),
    ),
    grid(
      columns: (1fr, 80%),
      info-key("实验项目名称："), info-value(info.title),
    ),
    grid(
      columns: (5fr, 14%, 3fr, 32%, 3fr, 21%),
      info-key("学生姓名："), info-value(info.name),
      info-key("专业："), info-value(info.major),
      info-key("学号："), info-value(info.id),
    ),
    grid(
      columns: (7fr, 45%, 5fr, 20%),
      info-key("同组学生姓名："), info-value(info.collaborator),
      info-key("指导教师："), info-value(info.advisor),
    ),
    grid(
      columns: (4fr, 41%, 4fr, 9%, 1fr, 5%, 1fr, 5%, 1fr),
      info-key("实验地点："), info-value(info.location),
      info-key("实验日期："),
      info-value(info.year), info-key("年"),
      info-value(info.month), info-key("月"),
      info-value(info.day), info-key("日"),
    )
  )
}

#let project(
  ..args
) = {
  let year = str(datetime.today().year())
  let month = str(datetime.today().month())
  let day = str(datetime.today().day())
  let info = args.named() + (
    title: " ",
    course: " ",
    name: " ",
    id: " ",
    collaborator: " ",
    advisor: " ",
    college: " ",
    department: " ",
    major: " ",
    location: " ",
    type: " ",
    year: year,
    month: month,
    day: day,
    date: year + " 年 " + month + " 月 " + day + " 日 "
  )

  (
    cover: (..args) => {
      cover(info:info,..args)
    },
    report-title: (..args) => {
      report-title(info:info,..args)
    },
    doc: (body) => {
      set page(numbering: (..numbers) => {
      if numbers.pos().at(0) > 1 {
          numbering("1", numbers.pos().at(0) - 1)
        }
      })
      set text(font: "Linux Libertine", lang: "en")
      set par(
        first-line-indent: 1em,
        justify: true
      )
      set heading(numbering: "1.1 ")
      set list(indent: 1em, body-indent: 1em)
      set enum(indent: 1em, body-indent: 1em)

      show heading: it => {
        it
        v(5pt)
        fake-par
      }
      
      show terms: it => {
        set par(first-line-indent: 0pt)
        set terms(indent: 10pt, hanging-indent: 9pt)
        it
        fake-par
      }
      
      show raw: it => {
        set text(font: ("Lucida Sans Typewriter", "Source Han Sans HW SC"))
        if it.lines.len() > 1 [
            #it
            #fake-par
        ] else [
            #it
        ]
      }
      show enum: it => {
        it
        fake-par
      }

      show list: it => {
        it
        fake-par
      }

      show figure: it => {
        it
        fake-par
      }

      show table: it => {
        it
        fake-par
      }
      body
    }
  )
}