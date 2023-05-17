import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import sys

# Load the CSV file
df = pd.read_csv(sys.argv[1], parse_dates=['Timestamp'])

# Set the timestamp as the index of the dataframe
df.set_index('Timestamp', inplace=True)

# Create the plot
fig, ax = plt.subplots()
df[['Avg Download (Mbps)', 'Avg Upload (Mbps)']].plot(
    kind='line', ax=ax, marker='o')

# Set the title and labels
plt.title('STEL bandwidth')
plt.xlabel('Timestamp')
plt.ylabel('Mbps')

# Format the x-axis to handle date properly
ax.xaxis.set_major_locator(mdates.DayLocator(
    interval=7))  # interval set to 7 days
ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))

# Subdivide the y-axis into steps of 5 and limit it to 50
plt.yticks(range(0, 51, 5))

# Enable the grid
plt.grid(True)

# Rotate and align the tick labels so they look better
fig.autofmt_xdate()

# Save the plot to a file
plt.savefig('output.png')

# Show the plot
plt.show()
