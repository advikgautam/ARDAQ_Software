# Amrita Racing — Telemetry Analysis (Phase 1)

One session log in → every calculation and graph out → one PDF report.

This is the first step of the team's telemetry & data visualization project. It takes a CSV of sensor readings from the car and automatically runs the calculations we can do **with the sensors already installed** (IMU + brake pressure), plotting each one in order.

## What's in this repo

| File | What it is |
|---|---|
| `amrita_racing_phase1_analysis.m` | The MATLAB script. Loads the CSV, runs all 16 calculations, makes the graphs. |
| `input_sample.csv` | Synthetic demo session: a straight-line brake test + one corner + a kerb strike. |
| `input_sample_autocross_lap.csv` | Synthetic demo session: a 70 s autocross-style lap (launch, 3 braking zones, hairpin, sweeper, chicane, kerb strike). |
| `docs/` | Planning documents: the Excel sheet (all calculations, sensors, costs) and the team presentation. |

> The sample CSVs are **fake data** made for testing. They are not from the real car.

## Requirements

- MATLAB (any recent version, student license is fine)
- No extra toolboxes needed

## Quick start

1. Download or clone this repo.
2. Open MATLAB and set the **Files** panel to the repo folder.
3. Double-click `amrita_racing_phase1_analysis.m` to open it.
4. Near the top, choose your data file:
   ```matlab
   INPUT_FILE = "input_sample.csv";   % or "input_sample_autocross_lap.csv"
   ```
5. Click **Run**. One figure window opens per calculation, and short text summaries print in the Command Window.

## Make the one-file PDF report

In the MATLAB Command Window, run:

```matlab
publish('amrita_racing_phase1_analysis.m','pdf')
```

MATLAB re-runs everything and writes one PDF (code, graphs and summaries in order) into a new `html/` folder next to the script.

## Input file format

One CSV, one row per sample, with these exact column names:

```
timestamp_ms, ax_g, ay_g, az_g, roll_rate_dps, pitch_rate_dps, yaw_rate_dps, brake_f_bar, brake_r_bar
```

| Column | Meaning | Unit |
|---|---|---|
| `timestamp_ms` | Time of the sample | milliseconds |
| `ax_g` / `ay_g` / `az_g` | Longitudinal / lateral / vertical acceleration | g |
| `roll_rate_dps` / `pitch_rate_dps` / `yaw_rate_dps` | Rotation rates | deg/s |
| `brake_f_bar` / `brake_r_bar` | Front / rear brake line pressure | bar |

If a column is missing, the script stops with a message naming it.

## Using real car data

1. Put the real log CSV in the same folder as the script.
2. Change `INPUT_FILE` at the top of the script to its name.
3. Run again. Nothing else changes.

## Settings you can edit (top of the script)

| Setting | Default | Used for |
|---|---|---|
| `MAX_GRIP_G` | 1.2 | Assumed tyre grip limit for the G-G circle and grip-utilisation %. Placeholder — replace with a real value. |
| `IMPACT_THRESHOLD_G` | 2.0 | Combined ax/ay level that counts as an impact event. |

## What it calculates

1. Longitudinal acceleration vs time
2. Lateral acceleration vs time
3. Vertical acceleration vs time
4. Roll rate vs time
5. Pitch rate vs time
6. Yaw rate vs time
7. G-G diagram (friction circle)
8. Friction circle utilisation (%) vs time
9. Roll angle estimate (integrated roll rate)
10. Pitch angle estimate (integrated pitch rate)
11. Skid-pad summary: peak lateral g and roll rate at that moment
12. Impact / shock event log
13. Brake line pressure, front, vs time
14. Brake line pressure, rear, vs time (plotted together with #13)
15. Brake bias ratio vs time
16. Brake pressure vs deceleration (calibration curve)

## Known limitations

- Roll and pitch angles come from integrating gyro rates, so they **drift** over time. Treat them as indicative only.
- There is no speed, lap time, wheel slip, suspension, steering or tyre data yet. Those sensors are not installed, so those calculations are not possible in this phase.
- The brake bias ratio is a pressure ratio, not the force split at the tyres.
- The two sample files are synthetic.

## Planned next

Add calculations as new sensors are installed (GPS, wheel speed, steering angle, suspension travel), following the priority order in `docs/`.

## Contributing

- Keep the input column names above unchanged, or update this README and the script together.
- One calculation per `%%` section in the script, so `publish` keeps the report in order.
- Don't commit real session logs unless the team agrees where they should live.
