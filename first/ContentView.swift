//
////
////  ContentView.swift
////  first
////
////  Created by Asif on 1/1/25.
////
//
//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var selectedOption: String? = nil
//    @State private var showDetails: Bool = false
//
//    var body: some View {
//        ZStack {
//            // Background with Radial Gradient
//            ZStack {
//                RadialGradient(
//                    gradient: Gradient(colors: [.blue, .purple, .pink]),
//                    center: .center,
//                    startRadius: 50,
//                    endRadius: 500
//                )
//                .ignoresSafeArea()
//
//                Color.black.opacity(0.2)
//                    .ignoresSafeArea()
//                    .blur(radius: 30)
//            }
//            
//            // Snowfall Animation
//            SnowfallView()
//                .ignoresSafeArea()
//
//            VStack {
//                // Top Section with "Dashboard" Title
//                HStack {
//                    Text("Dashboard")
//                        .font(.largeTitle)
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding(.leading)
//
//                    Spacer()
//
//                    // Fixed Logout Button
//                    Button(action: {
//                        showDetails(for: "Logout")
//                    }) {
//                        Image(systemName: "power")
//                            .font(.title2)
//                            .padding()
//                            .background(Color.red.opacity(0.8))
//                            .clipShape(Circle())
//                            .foregroundColor(.white)
//                            .shadow(radius: 5)
//                    }
//                    .padding(.trailing)
//                }
//                .padding(.top)
//                .padding(.horizontal)
//
//                Spacer()
//
//                // Dashboard Cards
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 25) {
//                        DashboardCard(icon: "cloud.sun.fill", title: "Weather", color: .blue)
//                            .onTapGesture {
//                                showDetails(for: "Weather")
//                            }
//
//                        DashboardCard(icon: "gamecontroller.fill", title: "Game 1", color: .green)
//                            .onTapGesture {
//                                showDetails(for: "Game 1")
//                            }
//
//                        DashboardCard(icon: "gamecontroller.fill", title: "Game 2", color: .purple)
//                            .onTapGesture {
//                                showDetails(for: "Game 2")
//                            }
//
//                        DashboardCard(icon: "list.number", title: "Leaderboard", color: .orange)
//                            .onTapGesture {
//                                showDetails(for: "Leaderboard")
//                            }
//                    }
//                    .padding(.horizontal)
//                }
//
//                Spacer()
//            }
//
//            // Detail View
//            if showDetails, let selectedOption = selectedOption {
//                VStack {
//                    Text("\(selectedOption) Details")
//                        .font(.title)
//                        .bold()
//                        .padding()
//                        .foregroundColor(.white)
//
//                    Button("Close") {
//                        withAnimation {
//                            showDetails = false
//                        }
//                    }
//                    .padding()
//                    .background(Color.white.opacity(0.8))
//                    .cornerRadius(8)
//                    .foregroundColor(.black)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.black.opacity(0.6))
//                .transition(.move(edge: .bottom))
//            }
//        }
//    }
//
//    private func showDetails(for option: String) {
//        withAnimation {
//            selectedOption = option
//            showDetails = true
//        }
//    }
//}
//
//struct SnowfallView: View {
//    @State private var snowflakes: [Snowflake] = []
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                ForEach(snowflakes) { snowflake in
//                    Text("❄️") // Use the snowflake emoji
//                        .font(.system(size: snowflake.size)) // Adjust size dynamically
//                        .opacity(snowflake.opacity) // Control opacity
//                        .position(x: snowflake.x, y: snowflake.y) // Set position
//                }
//            }
//            .onAppear {
//                // Timer to generate snowflakes with slower rate
//                Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
//                    if snowflakes.count < 30 { // Limit maximum snowflakes on screen
//                        addSnowflake(geometry: geometry)
//                    }
//                }
//
//                // Timer to move the snowflakes
//                Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
//                    updateSnowflakes(geometry: geometry)
//                }
//            }
//        }
//    }
//
//    private func addSnowflake(geometry: GeometryProxy) {
//        // Randomize snowflake creation probability
//        if Int.random(in: 0...1) == 0 { return } // 50% chance to skip creation
//
//        let newSnowflake = Snowflake(
//            id: UUID(),
//            x: CGFloat.random(in: 0...geometry.size.width),
//            y: -10, // Start slightly above the top
//            size: CGFloat.random(in: 5...20), // Adjust size range for emoji
//            opacity: Double.random(in: 0.6...1.0), // Slightly transparent
//            speed: CGFloat.random(in: 0.3...0.6) // Speed of fall
//        )
//        snowflakes.append(newSnowflake)
//    }
//
//    private func updateSnowflakes(geometry: GeometryProxy) {
//        for index in snowflakes.indices {
//            // Update snowflake's position
//            snowflakes[index].y += snowflakes[index].speed
//
//            // Remove snowflakes that are out of bounds
//            if snowflakes[index].y > geometry.size.height + 10 {
//                snowflakes.remove(at: index)
//                break
//            }
//        }
//    }
//}
//
//struct Snowflake: Identifiable {
//    let id: UUID
//    var x: CGFloat
//    var y: CGFloat
//    var size: CGFloat
//    var opacity: Double
//    var speed: CGFloat
//}
//
//
//
//struct DashboardCard: View {
//    var icon: String
//    var title: String
//    var color: Color
//
//    var body: some View {
//        VStack {
//            Image(systemName: icon)
//                .font(.system(size: 50))
//                .foregroundColor(.white)
//                .padding()
//
//            Text(title)
//                .font(.headline)
//                .foregroundColor(.white)
//                .padding(.horizontal)
//        }
//        .frame(width: 180, height: 180)
//        .background(color)
//        .cornerRadius(20)
//        .shadow(radius: 10)
//    }
//}
//
//
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView()
//           
//        }
//    }
//}
//
