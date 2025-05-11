import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let description: String
}

struct MapView: View {
    @State private var selectedLocation: Location? = nil
    @State private var cameraPosition: MapCameraPosition

    let locations: [Location] = [
        Location(name: "Eaterie 1", coordinate: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832), description: "A cozy place for breakfast."),
        Location(name: "Eaterie 2", coordinate: CLLocationCoordinate2D(latitude: 43.6548, longitude: -79.3849), description: "Famous for its lunch specials."),
        // Add more locations as needed
    ]

    init() {
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        _cameraPosition = State(initialValue: .region(initialRegion))
    }

    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                                .onTapGesture {
                                    withAnimation {
                                        selectedLocation = location
                                    }
                                }
                            Text(location.name)
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .mapStyle(.standard)
            .edgesIgnoringSafeArea(.all)

            if let location = selectedLocation {
                VStack {
                    Text(location.name)
                        .font(.headline)
                        .padding(.top)

                    Text(location.description)
                        .padding([.horizontal, .bottom])

                    Button("Close") {
                        withAnimation {
                            selectedLocation = nil
                        }
                    }
                    .padding(.bottom)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
                .transition(.move(edge: .top))
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
