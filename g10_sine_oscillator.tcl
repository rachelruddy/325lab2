# Create and map the work library
vlib work
vmap work work

# Compile the DUT (design under test)
vcom -2008 g10_sine_oscillator.vhd

# Compile the testbench
vcom -2008 g10_sine_oscillator_tb.vhd

# Start the simulation
vsim work.g10_sine_oscillator_tb

# Add all signals to the wave window
add wave -recursive *

# Run the simulation for enough time to cover all tests
# (reset ends ~32ns, 10 clocks @ 10ns each = 100ns, plus margin)
run 20000 ns

# Print a message when done
echo "Simulation complete. Check wave window and transcript for assertion results."