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

= System Design

== Prelab Exercise

The FPGA board provides only a 100MHz clock source, which is $10^8$ times faster than the
required clock. So I have designed a component of a frequency divider that slow down the output
by $10^8$ times for a clock input. The conceptual diagram of the frequency divider is in @freq_divider_concep:

#figure(
  image("counter_report.assets/20240608003809.png"),
  caption: "Conceptual Diagram of Counter based Divider",
) <freq_divider_concep>

#figure(
  image("counter_report.assets/divider_1.png"),
  caption: "Elaborated Schematic of Divider",
) <freq_divider_elab>

The component of frequency divider has one input `clk` and one output `div`. Because the clock source of FPGA board is 100MHz and
what we need is the clock of 1Hz, the upper limit of the counter is set to the frequency of the main clock, which is `05F5_E100` in hex.

The behavioral simulation results indicated that the uncertain state at the powering up will not vanish spontaneously with the assign inside the block, rather than staying at such unstability. Therefore, an exterior or interior boot time reset operation is mandatory. To avoid of using exterior reset signal, an synthesizable `initial` block is introduced to ensure the initial state of the counter register bank.

The HDL code is provided as @divider_code

== Lab Exercise

The top level structure of the overall design is shown as @top_level:

#figure(
  image("counter_report.assets/20240608004631.png"),
  caption: "Top-level Schematics of the Design",
) <top_level>

While the 4-digit counter unit inside the top-level block are implemented with the following additional functionalities:

- Synchronous loading and resetting
- Asynchronous enable/hold line
- Reverse counting (up and down counting)
- Parameterized lower and upper bounds
- Full carriage and borrowing support

These features are enabled by expanding the combinational logic part of the counter unit with the corresponding arithmetric logics. For the loading and resetting features, the loaded data or zeros are directly connected to the register bank. For the reverse counting feature, there is one selection line that controls whether the registers are added or minus with 1 at each positive clock edge. For the carriage and borrowing supports, the carriage or borrowing input digit is summed up with the add/minus logic with respection to the current add or minus counting status.

The full elaborated schematic is shown as @counter.

#figure(
  image("counter_report.assets/counter_1.png"),
  caption: "Elaborated Schematics of the Counter Unit",
) <counter>

The HDL code of the counter unit is provided below:

= Experiment Results

#let cell(h: 100%, ali: center, imgpath: "") = rect(
  inset: 8pt,
  fill: rgb("e4e5ea"),
  width: 100%,
  height: h,
  radius: 6pt,
)[
  #align(ali)[
    #image(imgpath)
  ]
]

The following testbench are used to provide simulation stimulus. Since the output under 0.1MHz main clock frequency and the output under 1Hz main clock frequency should be identical for the same digital circuit, the simulation frequency is selected as 0.1MHz to minimize computational burdens.

== Pre-Synthesis Behavioral Simulation

The results of behavioral simulation with increasing 1 at frequency 0.1MHz is shown as

#figure(
  grid(
    align: center,
    columns: (auto, auto),
    rows: (15%, 15%),
    gutter: 1%,
    cell(imgpath: "counter_report.assets/image-20230328132148310.png"),
    cell(imgpath: "counter_report.assets/image-20230328132351281.png"),
    cell(imgpath: "counter_report.assets/image-20230328132438185.png"),
    cell(imgpath: "counter_report.assets/image-20230328132631557.png"),
    cell(imgpath: "counter_report.assets/image-20230328133140395.png"),
    cell(imgpath: "counter_report.assets/image-20230328133101777.png"),
  ),
  caption: "Details of Behavioral simulation result with increasing 1 by 10μs",
)

From the details of Behavioral simulation result with increasing $1$ by $10 "μs"$, the result of simulation is in line with our expectation. When the logic value of `reset` is $1$, the counter is initialized to `000`, which satisfy asynchronous reset function. The load number are loaded when both of `clk` and `load` are $1$, which satisfy synchronous load function. The counter of frequency divider start counting at the first rising edge of `clk` after the logic value of `load` is 0. The whole decimal counter increase by 1 after $10 "μs"$. What's more, the duration of high level of `enable` is the period of `clk`, which ensures the whole decimal counter increase by 1 after $10 "μs"$.

​ Then we test the simulation when the value in the corresponding position is more than 9. The number which will loaded is `0010 1100 0100`. The result of simulation is as below:

#figure(
  image(
    "counter_report.assets/image-20230328123934213.png",
    width: 60%,
  ),
  caption: "Behavioral simulation result for the value in the corresponding position is more than 9",
)

The loaded number is `304`, which is in line with our expectation.

== Post-Synthesis Functional Simulation

#figure(
  image(
    "counter_report.assets/image-20230328134249846.png",
    width: 60%,
  ),
  caption: "Post-Synthesis functional simulation result",
)

The post-synthesis functional simulation is also in line with our design and the result of behavioral simulation. However, the result of post-synthesis timing simulation is a little different from that of behavioral simulation.

It is obviously that there exists a delta delay in the beginning, which is different from behavioral simulation and postsynthesis functional simulation. The value of delta delay is $1.340 "ns"$. What's more, the numbers of input are not loaded until about $4.303 "ns"$ after the rising edge of `load`. The reason behind this is that although multiple signal assignment statements are executed concurrently in simulated time and are referred to as concurrent signal assignment statements, a small delay——delta delay will be automatically set in order to make a logical sequence of signals transmission.

#figure(
  grid(
    align: center,
    columns: (auto, auto),
    rows: (15%, 15%),
    gutter: 1%,
    cell(imgpath: "counter_report.assets/image-20230328135603373.png"),
    cell(imgpath: "counter_report.assets/image-20230328135926589.png"),
    cell(imgpath: "counter_report.assets/image-20230328135658098.png"),
    cell(imgpath: "counter_report.assets/image-20230328135750781.png"),
  ),
  caption: "Post-implementation functional simulation result",
)

​ As we can see, there is instantaneous change in `d10_tb`. One possible reason is that adding $1$ in the combinational circuit when the output is `'d299`(decimal), `d1_tb` and `d10_tb` should change from $9$ to $0$. The binary code for $9$ is $1001$. The signal that changes the highest bit from $1$ to $0$ arrives before the signal that changes the lowest bit from $1$ to $0$. When the highest bit changes from $1$ to $0$, the value of the lowest bit is still $1$ in that very short period of time. That's why there is instantaneous change in `d10_tb`.

== Post-Synthesis Timing Simulation

#figure(
  image(
    "counter_report.assets/image-20230328164622659.png",
    width: 60%,
  ),
  caption: "Post-Synthesis timing simulation result",
)

The post-implementation functional simulation is also in line with our design and the result of behavioral simulation.

#figure(
  grid(
    align: center,
    columns: (auto, auto),
    rows: (15%, 15%),
    gutter: 1%,
    cell(imgpath: "counter_report.assets/image-20230328165413654.png"),
    cell(imgpath: "counter_report.assets/image-20230328165752571.png"),
    cell(imgpath: "counter_report.assets/image-20230328165543424.png"),
    cell(imgpath: "counter_report.assets/image-20230328165715831.png"),
  ),
  caption: "Post-implementtation timing simulation result",
)

It is obviously that the delays at the beginning of `d1_tb`, `d10_tb` and `d100_tb` are different, which are almost twice as that in post-implementation timing simulation. What's more, the number of input `data1_tb` are not loaded until about $8.389$ns after the rising edge of `load`, which are also almost twice as that in post-implementation timing simulation. That's due to layout, routing and different time delay of gate circuits in post-implementation timing simulation.

​The schematic is very similar to our block diagram, which verify our code’s correctness.

#figure(
  image(
    "counter_report.assets/20240608024457.png",
    width: 90%,
  ),
  caption: "Post-Synthesis Schematic",
)

== Onboarding

In order to burn the program to FPGA, we need to write constraints file. The code for constraints file is shown in XDC file @xdc_file.

The corresponding layout of the hardware pins are shown below:

#figure(
  image(
    "counter_report.assets/image-20230328173008497.png",
    width: 40%,
  ),
  caption: "Post-Synthesis timing simulation result",
)

And finally, we set the frequency to 1Hz and generate the bitstream and program to the board, the decimal counter result is correct.

#figure(
  image(
    "counter_report.assets/image-20230328183838728.png",
    width: 60%,
  ),
  caption: "Post-Synthesis timing simulation result",
)

= Conclusion and Analysis

The main part of this report is the process of digital design of three-digit decimal counter using VIVADO. There are some important points that need to be stressed again:

1.  Synchronization means under the excitation of clock signal, in the rising or falling edge of the clock, the trigger carries out the corresponding operation.
2. Asynchrony means that the trigger performs corresponding operation at the rising or falling edge of the signal under the excitation signal.
3. The first segment of two-segment coding style is for a synchronous section or a synchronous section with asynchronous inputs. The first segment of two-segment coding style is for a combinational section.

= Appendix / Code

#show figure: set block(breakable: true)

== Divider

#figure(
  align(left, raw(read("../../three_digit_counter/three_digit_counter.srcs/sources_1/new/divider.v"), lang: "verilog")),
  kind: auto,
  supplement: [Code],
  caption: "Divider",
) <divider_code>

#pagebreak()

== Counter

#figure(
  align(left, raw(read("../../three_digit_counter/three_digit_counter.srcs/sources_1/new/counter.v"), lang: "verilog")),
  kind: auto,
  supplement: [Code],
  caption: "Counter Unit",
) <counter_code>

#pagebreak()

== LED Decoder

#figure(
  align(
    left,
    raw(read("../../three_digit_counter/three_digit_counter.srcs/sources_1/new/led_decoder.v"), lang: "verilog"),
  ),
  kind: auto,
  supplement: [Code],
  caption: "Divider",
) <led_decoder>

#pagebreak()

== Testbench

#figure(
  align(left, raw(lang: "verilog", read("./tb.txt"))),
  kind: auto,
  supplement: [Code],
  caption: "Testbench",
) <tb_code>

#pagebreak()

== XDC Constraints

#figure(
  align(
    left,
    raw(read("./xdc.txt"), lang: "verilog"),
  ),
  kind: auto,
  supplement: [Code],
  caption: "XDC",
) <xdc_file>