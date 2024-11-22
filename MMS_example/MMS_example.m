% Parameters
L = 1;             % Length of the domain
T = 1;          % Time duration
Nx = 21;           % Number of space grid points
Nt = 1000;          % Number of time steps
dx = L / (Nx - 1); % Space step size
dt = T / Nt;       % Time step size
alpha = dt / (dx^2); % Stability condition (alpha <= 0.5)
 
% Initializing the grid
x = linspace(0, L, Nx); % Space grid
t = linspace(0, T, Nt); % Time grid
u = zeros(Nx, Nt);      % Solution matrix initialized to 0
 
% Time-stepping loop
for n = 1:Nt-1
    % Update the interior points using FTCS scheme
    for i = 2:Nx-1
        u(i, n+1) = u(i, n) + alpha * (u(i+1, n) - 2*u(i, n) + u(i-1, n)) ...
                    + dt * (x(i)^2 * cos(t(n)) - 2 * sin(t(n)));
    end
    % Apply boundary conditions
    u(1, n+1) = 0; % u(0, t) = 0
    % Apply Neumann boundary condition at x = 1
    u(Nx, n+1) = u(Nx-1, n+1) + 2 * sin(t(n)) * dx; % du/dx = 2*sin(t)
    % Apply Dirichlet boundary condition at x = 1
%     u(Nx, n+1) = x(Nx)^2*sin(n*dt);
    % Plot and save snapshot at each time step
    figure('Visible', 'off'); % Prevent displaying during iteration
    plot(x, u(:, n+1), '-k.', 'LineWidth', 2,'MarkerSize',12);
    hold on
    plot(x,x.^2*sin(n*dt),'--r', 'LineWidth', 2)
    title(['Solution at t = ', num2str(t(n+1))]);
    xlim([0,1])
    ylim([0,1])
    xlabel('x');
    ylabel('u(x,t)');
    saveas(gcf, ['./pics/snapshot_t', sprintf('%05d', n+1), '.png']);
    close; % Close the figure to save memory
end