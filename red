flowchart LR
  %% =======================
  %% Wearable Layer
  %% =======================
  subgraph W[Wearable Therapy Patch]
    S1[IMU (9-DoF)\nAccel/Gyro/Mag] --> MCU[MCU/SoC\n(ESP32-class)]
    S2[sEMG Front-End (optional)\nADC + Filtering] --> MCU
    S3[Skin Temp/Impedance (optional)\nSafety/Contact] --> MCU
    
    MCU --> DSP[On-device DSP\nFiltering + Feature Extraction]
    DSP --> CTRL[Closed-loop Controller\n(PID/Adaptive/RL-lite)]
    CTRL --> NMES[NMES Driver\nCurrent-controlled pulses]
    NMES --> E[Electrodes\n(paraspinal pairs)]
    
    MCU --> SAFE[Safety Supervisor\nlimits + watchdog + failsafe]
    SAFE --> NMES
  end

  %% =======================
  %% User + Mobile Layer
  %% =======================
  subgraph M[Mobile App / Edge UI]
    APP[Mobile App\nFeedback + Trends + Setup]
    APP -->|Therapy plan / clinician presets| CLOUD[(Optional Cloud)]
  end

  %% =======================
  %% Connectivity
  %% =======================
  MCU <-->|BLE| APP

  %% =======================
  %% Clinician / Research Layer
  %% =======================
  subgraph C[Clinician / Research Portal]
    DASH[Clinician Dashboard\nReports + Parameter Ranges]
    DASH --> CLOUD
    CLOUD --> MODEL[Model Updates\n(Thresholds/Classifier)]
  end

  %% =======================
  %% Data Logging
  %% =======================
  DSP --> LOG[Local Data Logging\nFlash/SD (optional)]
  LOG -->|Sync| APP
  APP -->|Encrypted upload (optional)| CLOUD
