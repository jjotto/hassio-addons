#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting SatDump NOAA APT Add-on..."

# Ensure the output directory exists
mkdir -p "${HA_CONFIG_OUTPUT_PATH}"
echo "Output path set to: ${HA_CONFIG_OUTPUT_PATH}"

# Construct the SatDump command based on configuration options
# The 'satdump' command within the rpatel3001/docker-satdump image might vary.
# This assumes a command-line interface similar to the original SatDump.
# Adjust the command if the Docker image uses a different entry point or parameters.

# Common RTL-SDR device string format: rtl_sdr:device_index=0
RTL_DEVICE_STRING="rtl_sdr:device_index=${HA_CONFIG_RTL_DEVICE_INDEX}"

# SatDump command for NOAA APT
# -i <input_device> (e.g., rtl_sdr:device_index=0)
# -f <frequency_hz>
# -s <sample_rate>
# -g <gain_db>
# -d <duration_seconds>
# -o <output_directory>
# --demod <demodulator_type> (e.g., APT)
# --decode <decoder_type> (e.g., NOAA_APT)
# --no-gui (assuming we want headless operation for an add-on)

# Convert frequency from MHz to Hz
FREQUENCY_HZ=$(echo "${HA_CONFIG_FREQUENCY_MHZ} * 1000000" | bc)

echo "Running SatDump with the following parameters:"
echo "  Device: ${RTL_DEVICE_STRING}"
echo "  Frequency: ${FREQUENCY_HZ} Hz (${HA_CONFIG_FREQUENCY_MHZ} MHz)"
echo "  Gain: ${HA_CONFIG_GAIN_DB} dB"
echo "  Sample Rate: ${HA_CONFIG_SAMPLE_RATE}"
echo "  Duration: ${HA_CONFIG_DURATION_SECONDS} seconds"
echo "  Output Path: ${HA_CONFIG_OUTPUT_PATH}"

# Execute SatDump
# Note: The exact command for SatDump within the Docker container might need
#       to be verified. This is a common pattern for command-line tools.
#       You might need to adjust 'satdump' to the actual executable path
#       if it's not in the PATH, or if the image uses a wrapper script.
satdump \
  -i "${RTL_DEVICE_STRING}" \
  -f "${FREQUENCY_HZ}" \
  -s "${HA_CONFIG_SAMPLE_RATE}" \
  -g "${HA_CONFIG_GAIN_DB}" \
  -d "${HA_CONFIG_DURATION_SECONDS}" \
  -o "${HA_CONFIG_OUTPUT_PATH}" \
  --demod APT \
  --decode NOAA_APT \
  --no-gui

echo "SatDump process finished."

# Keep the container running in the foreground to prevent Home Assistant from thinking it crashed.
# This is a common pattern for add-ons that run a single, finite task.
# For continuous operation (e.g., a web server), you'd typically have the main process
# keep running. For a capture script, you might want to loop it or trigger it via Home Assistant.
# For now, we'll just exit after the capture. If you want continuous capture,
# you'll need to add a loop here or use Home Assistant automations to restart the add-on.
