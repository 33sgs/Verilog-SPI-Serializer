## Verilog-SPI-Serializer
A basic SPI style serializer implemented in Verilog

## serializer.v

### Inputs
*i_Clock*: This is the main clock input to the module. The serial clock output, *o_SCLK* will be half this frequency.

*i_Data*: This is the *DATA_SIZE* bit wide parallel data input to the module. This is the data that will be serialized.

*i_Data_Ready*: This input tells the module that the data on the parallel input lines is valid and ready to be serialized. If this line is high on a positive *i_Clock* edge, the serialization will begin.

### Outputs
*o_CS*: Chip select line. This output is held high until transmission begins, at which point it is pulled low.

*o_SCLK*: Serial clock output. Always half the frequency of *i_Clock*. Do not use this signal to clock other modules.

*o_MOSI*: Serial data output. This data should be sampled on a rising edge of *o_SCLK*.

*o_Ready*: The module will drive this line high when it is ready to accept input from a higher level module. If this line is low, the serializer is currently sending serial data.

### Parameters
*DATA_SIZE*: The size of data to serialize per transaction. This affects how wide *i_Data* is along with the size of some internal registers.
*DIVIDE_BY*: This deterimes what to divide the serial clock by. It must be a power of 2. If ***DIVIDE_CLOCK*** is not defined, this does nothing.

### Define Statements
***DIVIDE_CLOCK***: Determines whether the serial clock will be divided by. If no additional division is required, comment out the define statement.
