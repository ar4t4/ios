import SwiftUI

class BackgroundController: ObservableObject {
    @Published var isDayTime: Bool = true

    func toggleBackground() {
        isDayTime.toggle()
    }
}

struct SwiftUIView: View {
    @StateObject private var backgroundController = BackgroundController()
    @State private var selectedOption: String? = nil
    @State private var showDetails: Bool = false

    var body: some View {
        ZStack {
            // Dynamic Background (Day/Night)
            ZStack {
                if backgroundController.isDayTime {
                    RadialGradient(
                        gradient: Gradient(colors: [.blue, .purple, .pink]),
                        center: .center,
                        startRadius: 50,
                        endRadius: 500
                    )
                } else {
                    RadialGradient(
                        gradient: Gradient(colors: [.black, .blue]),
                        center: .center,
                        startRadius: 50,
                        endRadius: 500
                    )
                }
            }
            .ignoresSafeArea()

            // Dark Overlay
            Color.black.opacity(0.2)
                .ignoresSafeArea()
                .blur(radius: 30)

            // Snowfall Animation
            SnowfallView()
                .ignoresSafeArea()

            VStack {
                // Top Section with "Dashboard" Title and Logout Button
                HStack {
                    Text("Dashboard")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.leading)

                    Spacer()

                    // Background Toggle Button (Day/Night)
                    Button(action: {
                        backgroundController.toggleBackground()
                    }) {
                        Image(systemName: backgroundController.isDayTime ? "moon.fill" : "sun.max.fill")
                            .font(.title2)
                            .padding()
                            .background(Color.yellow.opacity(0.8))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }

                    // Logout Button
                    Button(action: {
                        showDetails(for: "Logout")
                    }) {
                        Image(systemName: "power")
                            .font(.title2)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.trailing)
                }
                .padding(.top)
                .padding(.horizontal)

                Spacer()

                // Dashboard Cards (Scrollable)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25) {
                        DashboardCard(icon: "cloud.sun.fill", title: "Weather", color: .blue)
                            .onTapGesture {
                                showDetails(for: "Weather")
                            }

                        DashboardCard(icon: "gamecontroller.fill", title: "Game 1", color: .green)
                            .onTapGesture {
                                showDetails(for: "Game 1")
                            }

                        DashboardCard(icon: "gamecontroller.fill", title: "Game 2", color: .purple)
                            .onTapGesture {
                                showDetails(for: "Game 2")
                            }

                        DashboardCard(icon: "list.number", title: "Leaderboard", color: .orange)
                            .onTapGesture {
                                showDetails(for: "Leaderboard")
                            }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }

            // Detail View (Overlay when an option is selected)
            if showDetails, let selectedOption = selectedOption {
                VStack {
                    Text("\(selectedOption) Details")
                        .font(.title)
                        .bold()
                        .padding()
                        .foregroundColor(.white)

                    Button("Close") {
                        withAnimation {
                            showDetails = false
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.6))
                .transition(.move(edge: .bottom))
            }
        }
    }

    // Show detail overlay
    private func showDetails(for option: String) {
        withAnimation {
            selectedOption = option
            showDetails = true
        }
    }
}

// Snowfall Animation View
struct SnowfallView: View {
    @State private var snowflakes: [Snowflake] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(snowflakes) { snowflake in
                    Text("❄️")
                        .font(.system(size: snowflake.size))
                        .opacity(snowflake.opacity)
                        .position(x: snowflake.x, y: snowflake.y)
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                    if snowflakes.count < 30 {
                        addSnowflake(geometry: geometry)
                    }
                }

                Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                    updateSnowflakes(geometry: geometry)
                }
            }
        }
    }

    private func addSnowflake(geometry: GeometryProxy) {
        if Int.random(in: 0...1) == 0 { return }
        let newSnowflake = Snowflake(
            id: UUID(),
            x: CGFloat.random(in: 0...geometry.size.width),
            y: -10,
            size: CGFloat.random(in: 5...20),
            opacity: Double.random(in: 0.6...1.0),
            speed: CGFloat.random(in: 0.3...0.6)
        )
        snowflakes.append(newSnowflake)
    }

    private func updateSnowflakes(geometry: GeometryProxy) {
        for index in snowflakes.indices {
            snowflakes[index].y += snowflakes[index].speed
            if snowflakes[index].y > geometry.size.height + 10 {
                snowflakes.remove(at: index)
                break
            }
        }
    }
}

// Snowflake Model
struct Snowflake: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var speed: CGFloat
}

// Dashboard Card View
struct DashboardCard: View {
    var icon: String
    var title: String
    var color: Color

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.white)
                .padding()

            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
        }
        .frame(width: 180, height: 180)
        .background(color)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
