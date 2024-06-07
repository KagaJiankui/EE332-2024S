#import "template.typ": *

#show: project.with(
  title: "EE332 Lab2 Exercise4",
  authors: (
    (
      name_cn: "仇琨元",
      name_en: "Qiu Kunyuan",
      affiliation: "Dept. Electric and Electronic Engineering of SUSTech",
      contact: link("mailto://11913019@mail.sustech.edu.cn")[11913019\@mail.sustech.edu.cn],
    ),
  ),
  show_info: true,
)

= Project Introduction

The purpose of this lab is to design and realize a three-digit decimal counter. The design has
some important functions, including an asynchronous reset function, a synchronous load function
to set a start number of the counting, the function of increasing 1 for every 1 second and function
of displaying the counting results on the 12 LEDs. The asynchronous reset function is realized by
using a push button to initialize the counter to 000. The synchronous load function is realized by
using a switch to turn on or turn off the load mode and use 12 switches to set the start number.

= Experiment Results

== Prelab Exercise

The FPGA board provides only a 100MHz clock source, which is $10^8$ times faster than the
required clock. So I have designed a component of a frequency divider that slow down the output
by $10^8$ times for a clock input. The conceptual diagram of the frequency divider is in @freq_divider_concep:

#figure(
  image("counter_report.assets/20240608003809.png"),
  caption: "Conceptual Diagram of Counter based Divider"
) <freq_divider_concep>

#figure(
  image("counter_report.assets/divider_1.png"),
  caption: "Elaborated Schematic of Divider",
) <freq_divider_elab>

The component of frequency divider has one input `clk` and one output `div`. Because the clock source of FPGA board is 100MHz and
what we need is the clock of 1Hz, the upper limit of the counter is set to the frequency of the main clock, which is `05F5_E100` in hex.

The behavioral simulation results indicated that the uncertain state at the powering up will not vanish spontaneously with the assign inside the block, rather than staying at such unstability. Therefore, an exterior or interior boot time reset operation is mandatory. To avoid of using exterior reset signal, an synthesizable `initial` block is introduced to ensure the initial state of the counter register bank.

The HDL code is provided as follows:

#raw(read("../../three_digit_counter/three_digit_counter.srcs/sources_1/new/divider.v"), lang:"verilog")

== Lab Exercise

The top level structure of the overall design is shown as @top_level:

#figure(
  image("counter_report.assets/20240608004631.png"),
  caption: "Top-level Schematics of the Design"
) <top_level>

While the 4-digit counter unit inside the top-level block are implemented with the following additional functionalities:

- Synchronous loading and resetting
- Asynchronous enable/hold line
- Reverse counting (up and down counting)
- Parameterized lower and upper bounds
- Full carriage and borrowing support