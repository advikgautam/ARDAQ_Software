# docs — Planning Documents

Background for the Phase 1 telemetry project: what we want to calculate, which sensors that needs, and what it costs. Read these to understand **why** the MATLAB script does what it does.

## Files

| File | What it is |
|---|---|
| `Amrita_Racing_Telemetry_Sensor_Calc_Plan.xlsx` | The master planning workbook (4 sheets, below). |
| `Amrita_Racing_Telemetry_Phase1.pptx` | The 11-slide presentation made for the team. |

## Excel workbook — sheet by sheet

| Sheet | Contents |
|---|---|
| **Calculations & Graphs** | Every calculation/graph useful for a Formula Student car (131), grouped by subsystem, with the sensor variables each one needs. |
| **Sensors & Variables** | The reverse view: every variable needed, mapped to a sensor type, example part, quantity and placement. |
| **Installed Sensors & Calcs** | What the car has **now** and what can be calculated with it. This is the sheet the Phase 1 script is built from. |
| **Sensor Cost Breakdown** | Approximate cost per sensor, split into Tier 1 / 2 / 3, with totals. |

### How to read "Installed Sensors & Calcs"

- **Block A, confirmed installed:** IMU and front/rear brake pressure. Source: VD Instrumentation Roadmap, Section 2.
- **Block B, presumed on car:** current sensor, voltage transducer, BMS, IMD, dual APPS, motor/controller CAN. They are part of the car's mandatory HV safety design (TVSD), but **nobody has confirmed their data is being logged**. Check with the CES subteam before relying on them.
- **Block C, not installed:** GPS, steering angle, wheel speed, suspension string pots, damper sensors.

### How to read the cost sheet

- All prices are **approximate**, in INR, component only (no GST, import duty, shipping, wiring or mounting).
- Real vendor listings were used for GPS, current sensor, voltage transducer, BMS and IMD. Everything else is an estimate.
- The BMS and IMD are the biggest uncertainty. They are presumed already on the car, so they don't count toward new spend.
- Treat it as a planning budget, not a quote.

| Tier | Meaning | Approx. new spend |
|---|---|---|
| Tier 1 | Buy now: GPS + 4 wheel speed sensors | ₹2,500 |
| Tier 2 | Next: suspension string pots, steering angle, brake disc temperature, LV current | ₹31,050 |
| Tier 3 | Later / optional: tyres, aero, chassis strain, environment | ₹42,550 |
| Total | All tiers | ₹76,100 |

## Presentation

Plain slides covering: why the project exists, how the list was built, calculation counts by subsystem, example graphs, sensor requirements with priority tiers, and the phased buying plan.

## Known discrepancy

The presentation's Tier 1 slides list **GPS** among the sensors "already on the car". That is wrong: the VD Instrumentation Roadmap says GPS is **not installed**. The Excel workbook has it correct (GPS is a new Tier 1 purchase). Where the two disagree, trust the Excel.

## Source documents

- Technical Vehicle System Documentation (TVSD), SUPRA SAEINDIA 2026
- Vehicle Dynamics Instrumentation & Testing Roadmap
