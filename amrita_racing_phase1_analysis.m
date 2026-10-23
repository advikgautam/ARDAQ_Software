%% Amrita Racing -- Telemetry Analysis, Phase 1 (IMU + Brake Pressure)
% One session log in, every Tier-1 calculation and graph out, in order.
%
% HOW TO RUN
%   Option A (quick look): open this file in MATLAB and click Run.
%                           Each section produces one figure window.
%   Option B (team report): in the Command Window, run:
%                           publish('amrita_racing_phase1_analysis.m','pdf')
%                           This creates ONE PDF with every section's code,
%                           graphs, and printed notes, in order.
%   Option C (Live Script): File > Save As > Live Script (.mlx), then use
%                           the Export button in the Live Editor toolbar.
%
% INPUT FILE REQUIRED (same folder as this script), columns:
%   timestamp_ms, ax_g, ay_g, az_g, roll_rate_dps, pitch_rate_dps,
%   yaw_rate_dps, brake_f_bar, brake_r_bar
% A synthetic demo file, input_sample.csv, is provided -- rename it to
% input.csv (or change INPUT_FILE below) to test the whole pipeline
% before any real session data exists.

%% 1. Configuration
INPUT_FILE          = "input_sample.csv";  % session log for this run
MAX_GRIP_G          = 1.2;    % assumed tyre grip limit, for friction-circle %
IMPACT_THRESHOLD_G  = 2.0;    % combined ax/ay magnitude that counts as an "event"

%% 2. Load and validate session data
T = readtable(INPUT_FILE);

required = ["timestamp_ms","ax_g","ay_g","az_g","roll_rate_dps", ...
            "pitch_rate_dps","yaw_rate_dps","brake_f_bar","brake_r_bar"];
missing = required(~ismember(required, string(T.Properties.VariableNames)));
if ~isempty(missing)
    error("Input file is missing required column(s): %s", strjoin(missing, ", "));
end

t = T.timestamp_ms / 1000;   % seconds, for every time-series plot below
fprintf("Loaded %d samples spanning %.1f seconds from %s\n", height(T), t(end)-t(1), INPUT_FILE);

%% 3. Longitudinal acceleration (ax) vs time
figure('Name','01 Longitudinal Acceleration');
plot(t, T.ax_g, 'LineWidth', 1.1); grid on;
xlabel('Time (s)'); ylabel('a_x (g)');
title('Longitudinal Acceleration vs Time');

%% 4. Lateral acceleration (ay) vs time
figure('Name','02 Lateral Acceleration');
plot(t, T.ay_g, 'LineWidth', 1.1); grid on;
xlabel('Time (s)'); ylabel('a_y (g)');
title('Lateral Acceleration vs Time');

%% 5. Vertical acceleration (az) vs time
figure('Name','03 Vertical Acceleration');
plot(t, T.az_g, 'LineWidth', 1.1); grid on;
xlabel('Time (s)'); ylabel('a_z (g)');
title('Vertical Acceleration vs Time');

%% 6. Roll rate vs time
figure('Name','04 Roll Rate');
plot(t, T.roll_rate_dps, 'LineWidth', 1.1); grid on;
xlabel('Time (s)'); ylabel('Roll rate (deg/s)');
title('Roll Rate vs Time');

%% 7. Pitch rate vs time
figure('Name','05 Pitch Rate');
plot(t, T.pitch_rate_dps, 'LineWidth', 1.1); grid on;
xlabel('Time (s)'); ylabel('Pitch rate (deg/s)');
title('Pitch Rate vs Time');

%% 8. Yaw rate vs time
figure('Name','06 Yaw Rate');
plot(t, T.yaw_rate_dps, 'LineWidth', 1.1); grid on;
xlabel('Time (s)'); ylabel('Yaw rate (deg/s)');
title('Yaw Rate vs Time');

%% 9. G-G diagram (friction circle)
figure('Name','07 G-G Diagram');
plot(T.ay_g, T.ax_g, '.', 'MarkerSize', 4); hold on; grid on; axis equal;
theta = linspace(0, 2*pi, 200);
plot(MAX_GRIP_G*cos(theta), MAX_GRIP_G*sin(theta), 'r--', 'LineWidth', 1.2);
xlabel('Lateral g (a_y)'); ylabel('Longitudinal g (a_x)');
title('G-G Diagram (Friction Circle)');
legend('Measured', sprintf('Assumed grip limit (%.1fg)', MAX_GRIP_G), 'Location','southoutside');

%% 10. Friction circle utilisation (%) vs time
util_pct = 100 * sqrt(T.ax_g.^2 + T.ay_g.^2) / MAX_GRIP_G;
figure('Name','08 Friction Circle Utilisation');
plot(t, util_pct, 'LineWidth', 1.1); grid on; ylim([0, max(110, max(util_pct)*1.1)]);
xlabel('Time (s)'); ylabel('Grip used (%)');
title('Friction Circle Utilisation vs Time');

%% 11. Roll angle estimate (integrated roll rate)
% NOTE: this drifts over long sessions since it is a running integral --
% treat as indicative, not an absolute angle, until a better reference exists.
roll_angle_deg = cumtrapz(t, T.roll_rate_dps);
figure('Name','09 Roll Angle Estimate');
plot(t, roll_angle_deg, 'LineWidth', 1.1); grid on;
xlabel('Time (s)'); ylabel('Roll angle estimate (deg)');
title('Roll Angle Estimate vs Time (integrated, drifts over time)');

%% 12. Pitch angle estimate (integrated pitch rate)
pitch_angle_deg = cumtrapz(t, T.pitch_rate_dps);
figure('Name','10 Pitch Angle Estimate');
plot(t, pitch_angle_deg, 'LineWidth', 1.1); grid on;
xlabel('Time (s)'); ylabel('Pitch angle estimate (deg)');
title('Pitch Angle Estimate vs Time (integrated, drifts over time)');

%% 13. Skid-pad lateral-g capacity and baseline roll rate
[peak_ay, idx_peak] = max(abs(T.ay_g));
fprintf("\n--- Skid-pad summary ---\n");
fprintf("Peak lateral acceleration : %.2f g, at t = %.2f s\n", peak_ay, t(idx_peak));
fprintf("Roll rate at that instant : %.1f deg/s\n", T.roll_rate_dps(idx_peak));

%% 14. Impact / shock event log
combined_g = sqrt(T.ax_g.^2 + T.ay_g.^2);
event_idx = find(combined_g > IMPACT_THRESHOLD_G);
figure('Name','11 Impact Event Log');
plot(t, combined_g, 'LineWidth', 1.0); hold on; grid on;
yline(IMPACT_THRESHOLD_G, 'r--', 'Threshold');
if ~isempty(event_idx)
    plot(t(event_idx), combined_g(event_idx), 'ro', 'MarkerFaceColor','r');
end
xlabel('Time (s)'); ylabel('Combined |a_x, a_y| (g)');
title('Impact / Shock Event Log');
fprintf("\n--- Impact events above %.1fg ---\n", IMPACT_THRESHOLD_G);
if isempty(event_idx)
    fprintf("No events this session.\n");
else
    for k = 1:numel(event_idx)
        fprintf("  t = %6.2f s   combined = %.2f g\n", t(event_idx(k)), combined_g(event_idx(k)));
    end
end

%% 15. Brake line pressure -- Front & Rear vs time
figure('Name','12 Brake Line Pressure');
plot(t, T.brake_f_bar, 'LineWidth', 1.1); hold on;
plot(t, T.brake_r_bar, 'LineWidth', 1.1); grid on;
xlabel('Time (s)'); ylabel('Line pressure (bar)');
title('Brake Line Pressure vs Time');
legend('Front', 'Rear', 'Location','best');

%% 16. Brake bias ratio vs time
bias_ratio = T.brake_f_bar ./ (T.brake_f_bar + T.brake_r_bar);
figure('Name','13 Brake Bias Ratio');
plot(t, bias_ratio, 'LineWidth', 1.1); grid on; ylim([0 1]);
xlabel('Time (s)'); ylabel('Front bias ratio (F / (F+R))');
title('Brake Bias Ratio vs Time');

%% 17. Brake pressure vs deceleration (calibration curve)
avg_pressure = (T.brake_f_bar + T.brake_r_bar) / 2;
decel_g = -T.ax_g;   % positive = deceleration
figure('Name','14 Brake Pressure vs Deceleration');
scatter(avg_pressure, decel_g, 8, 'filled'); grid on;
xlabel('Average line pressure (bar)'); ylabel('Deceleration (g)');
title('Brake Pressure vs Deceleration (Bias Calibration Curve)');

%% 18. Done
fprintf("\nAll 16 Tier-1 calculations complete for %s.\n", INPUT_FILE);
fprintf("Run publish('amrita_racing_phase1_analysis.m','pdf') for the one-file team report.\n");
