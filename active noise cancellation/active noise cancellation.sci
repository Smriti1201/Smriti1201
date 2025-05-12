// Step 1: Set Up Environment
Fs = 8000; // Sampling frequency (Hz)
N = 2048;  // Number of samples
t = (0:N-1) / Fs; // Time vector

// Step 2: Generate Noise Signal
noise = 0.5 * rand(1, N); // White noise (1x2048)

// Step 3: Create Reference & Error Signals
desired_signal = sin(2 * %pi * 220 * t); // Pure tone signal (1x2048)
mixed_signal = desired_signal + noise; // Combine signal with noise (1x2048)

// Step 4: Implement LMS Adaptive Filter
mu = 0.01; // Learning rate
M = 32;    // Filter length
w = zeros(M, 1); // Initial filter weights
x = zeros(M, 1); // Input buffer

e = zeros(1, N); // Error signal array

for i = M:N
    x = noise(i:-1:i-M+1)'; // Reference noise (Transpose to column vector)
    y = w' * x; // Estimated anti-noise
    e(i) = mixed_signal(i) - y; // Error signal
    w = w + mu * e(i) * x; // Update filter weights
end

// Step 5: Analyze Noise Reduction
subplot(3,1,1); plot(t, desired_signal); title('Original Signal');
subplot(3,1,2); plot(t, mixed_signal); title('Signal + Noise');
subplot(3,1,3); plot(t, e); title('Filtered Signal (Noise Reduced)');

disp("ANC implementation completed successfully!");

//for real time view install external tools like SoX or PyScilab to handle real-time signals.
// Step 1: Set Up Real-Time Parameters
clc;
close;
Fs = 8000; // Sampling frequency (Hz)
M = 32;    // Filter length
mu = 0.01; // Learning rate
buffer_size = 512; // Frame size for real-time processing

// Step 2: Initialize Filter Parameters
w = zeros(M, 1); // Filter weights
x = zeros(M, 1); // Input buffer

// Step 3: Real-Time Processing Loop
while %t
    // Capture live noise input (use an external tool to stream audio)
    noise = get_live_audio(buffer_size); // Function to capture real-time noise

    // Generate anti-noise using LMS filter
    for i = M:buffer_size
        x = noise(i:-1:i-M+1)'; // Reference noise
        y = w' * x; // Estimated anti-noise
        e = noise(i) - y; // Error signal
        w = w + mu * e * x; // Update filter weights
    end

    // Play anti-noise output to cancel unwanted sound
    play_audio(-y, Fs); // Function to stream anti-noise signal

    // Break condition (Press a key to exit)
    if is_key_pressed() then break; end
end
