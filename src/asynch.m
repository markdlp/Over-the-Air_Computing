% Each node has random arrival jitter tau_k in [-tau_frac, +tau_frac]
tau_k = (-tau_frac + 2*tau_frac*rand(1, K)) * sps_val;

% Ensure delays are positive for the object by adding a common base offset
base_offset = tau_frac * sps_val + 2; 
tau_k_pos = base_offset + tau_k;

rx_delayed_nodes = zeros(size(tx_filtered));
for k = 1:K
    reset(fracDelay);
    rx_delayed_nodes(:, k) = fracDelay(tx_filtered(:, k), tau_k_pos(k));
end
rx_channel = sum(rx_delayed_nodes, 2);