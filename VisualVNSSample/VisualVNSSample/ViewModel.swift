import Foundation

class ViewModel: ObservableObject {
    @Published var salesmen: [Salesman] = []
    @Published var cities: [City] = []
    @Published var routes: [Route] = []
    @Published var solutions: [Solution] = []
    
    @Published var currentRoute: Route!
    @Published var updatedCurrentRoute: Route!
    @Published var currentSolution: Solution!
    @Published var currentPathes: [[String]] = [[]]
    @Published var currentSalesmen: [Salesman] = []
    
    @Published var currentSalesman: Salesman!
    @Published var updatedCurrentSalesman: Salesman!
    
    @Published var currentCity: City!
    @Published var updatedCurrentCity: City!
    
    @Published var tmpRoutesForCreatingPathes: [Route] = []
    
    @Published var id: UUID = UUID()
    @Published var name: String = ""
    @Published var depot: City!
    @Published var selectedDepot: Int = 0
    @Published var assignedCities: [City] = []
    @Published var assignedSalesmen: [Salesman] = []
    @Published var description: String = ""
    
    @Published var currentSelectedSalesman: Salesman!
    @Published var selectedSalesmanSet: Set<Salesman> = []
    @Published var notSelectedSalesmanSet: Set<Salesman> = []
    @Published var notSelectedSalesmanArray: [Salesman] = []
    
    @Published var currentSelectedCity: City!
    @Published var selectedCities: Set<City> = []
    @Published var notSelectedCitySet: Set<City> = []
    @Published var notSelectedCityArray: [City] = []
    
    @Published var isShowingNotSelectedCities: Bool = true
    @Published var updatedRoute: Route!
    
    
    @Published var isShowingNewSalesman: Bool = false
    @Published var isShowingNewCity: Bool = false
    @Published var isShowingNewRoute: Bool = false
    @Published var isRouteDetailPresented: Bool = false
    @Published var isCityDetailPresented: Bool = false
    @Published var isSalesmanDetailPresented: Bool = false
    @Published var isResultPresented: Bool = false
    @Published var isLoading: Bool = true
    @Published var isRouteEdited: Bool = false
    
    @Published var isLoggedOut = false
    
    
    @Published var htmlContent: String = ""
    
    func updateSalesmanByName(name: String){
        updatedCurrentSalesman.name = name
        updateExistingSalesman(salesman: updatedCurrentSalesman)
        setCurrentSalesman(salesman: updatedCurrentSalesman)
    }
    
    func updateSalesmanByDescription(description: String){
        updatedCurrentSalesman.description = description
        updateExistingSalesman(salesman: updatedCurrentSalesman)
        setCurrentSalesman(salesman: updatedCurrentSalesman)
    }
    
    func updateCityByName(name: String){
        updatedCurrentCity.name = name
        updateExistingCity(city: updatedCurrentCity)
        setCurrentCity(city: updatedCurrentCity)
    }
    
    func updateCityBySalesman(salesman: Salesman){
        updatedCurrentCity.salesman = salesman
        updateExistingCity(city: updatedCurrentCity)
        setCurrentCity(city: updatedCurrentCity)
    }
    
    func updateCityByAddress(address: String){
        updatedCurrentCity.address = address
        updateExistingCity(city: updatedCurrentCity)
        setCurrentCity(city: updatedCurrentCity)
    }
    
    func updateCityByDescription(description: String){
        updatedCurrentCity.description = description
        updateExistingCity(city: updatedCurrentCity)
        setCurrentCity(city: updatedCurrentCity)
    }
    
    func updateRouteByName(name: String){
        updatedCurrentRoute.name = name
        updateExistingRoute(route: updatedCurrentRoute)
        setCurrentRoute(route: updatedCurrentRoute)
    }
    
    func updateRouteByDepot(depot: City){
        updatedCurrentRoute.depot = depot
        updateExistingRoute(route: updatedCurrentRoute)
        setCurrentRoute(route: updatedCurrentRoute)
    }
    
    func updateRouteByDescription(description: String){
        updatedCurrentRoute.description = description
        updateExistingRoute(route: updatedCurrentRoute)
        setCurrentRoute(route: updatedCurrentRoute)
    }
    
    func updateRouteByCity(city: City){
        if updatedCurrentRoute.cities.contains(city){
            updatedCurrentRoute.cities.removeAll(where: {$0 == city})
        }
        else{
            updatedCurrentRoute.cities.append(city)
        }
        updateExistingRoute(route: updatedCurrentRoute)
        setCurrentRoute(route: updatedCurrentRoute)
        setNotSelectedCities()
    }
    
    func updateCurrentRouteByCity(city: City){
        if updatedCurrentRoute.cities.contains(city){
            updatedCurrentRoute.cities.removeAll(where: {$0 == city})
        }
        else{
            updatedCurrentRoute.cities.append(city)
        }
    
        setCurrentRoute(route: updatedCurrentRoute)
        setNotSelectedCities()
    }
    
    func setCurrentSalesman(salesman: Salesman){
        currentSalesman = salesman
        updatedCurrentSalesman = salesman
    }
    
    func setCurrentCity(city: City){
        currentCity = city
        updatedCurrentCity = city
    }
    
    func setCurrentRoute(route: Route){
        currentRoute = route
        updatedCurrentRoute = currentRoute
    }
    
    func setNewSalesman(){
        let newSalesman = Salesman(id: UUID(), name: "", description: "", createdAt: "default", updatedAt: "default")
        currentSalesman = newSalesman
        updatedCurrentSalesman = newSalesman
    }
    
    func setNewCity(){
        let newCity = City(id: UUID(), name: "", address: "", salesman: salesmen[0], description: "", createdAt: "default", updatedAt: "default")
        
        currentCity = newCity
        updatedCurrentCity = newCity
    }
    
    func setNewRoute(){
        let newRoute = Route(id: UUID(), name: "", depot: cities[0], cities: [], salesmen: [], description: "", createdAt: "default", updatedAt: "default")
        currentRoute = newRoute
        updatedCurrentRoute = newRoute
    }

    
    func setNotSelectedCities(){
        notSelectedCitySet = Set(cities).subtracting(updatedCurrentRoute.cities)
        notSelectedCityArray = Array(notSelectedCitySet)
    }
    
    func updateRouteBySalesman(salesman: Salesman){
        if updatedCurrentRoute.salesmen.contains(salesman){
            updatedCurrentRoute.salesmen.removeAll(where: {$0 == salesman})
        }
        else{
            updatedCurrentRoute.salesmen.append(salesman)
        }
        updateExistingRoute(route: updatedCurrentRoute)
        setCurrentRoute(route: updatedCurrentRoute)
        setNotSelectedSalesmen()
    }
    
    func updateCurrentRouteBySalesman(salesman: Salesman){
        if updatedCurrentRoute.salesmen.contains(salesman){
            updatedCurrentRoute.salesmen.removeAll(where: {$0 == salesman})
        }
        else{
            updatedCurrentRoute.salesmen.append(salesman)
        }
        setCurrentRoute(route: updatedCurrentRoute)
        setNotSelectedSalesmen()
    }
    
    func setNotSelectedSalesmen(){
        notSelectedSalesmanSet = Set(salesmen).subtracting(updatedCurrentRoute.salesmen)
        notSelectedSalesmanArray = Array(notSelectedSalesmanSet)
    }
    
    func searchSalesmanFromSalesmanID(salesmanID: UUID) -> Salesman{
        for salesman in salesmen {

            if salesman.id == salesmanID {
                return salesman
            }
        }
        return Salesman(id: UUID(), name: "unknown", description: "謎です。", createdAt: "now", updatedAt: "now")
    }
    
    func fetchAllRoutes() {
        APIClient.shared.fetchRoutes { fetchedRoutes in
            if let fetchedRoutes = fetchedRoutes {
                self.routes = fetchedRoutes
            }
        }
    }
    
    func createNewRoute(route: Route){
        let newRouteName = route.name
        let depotID = route.depot.id
        var cityIDs: [UUID] = []
        for city in route.cities {
            cityIDs.append(city.id)
        }
        var salesmanIDs: [UUID] = []
        for salesman in route.salesmen {
            salesmanIDs.append(salesman.id)
        }
        let description = route.description

        APIClient.shared.createRoute(
            name: newRouteName,
            depot: depotID,
            cities: Array(cityIDs),
            salesmen: Array(salesmanIDs),
            description: description
        ) { success in
            if success {
                print("create route ok")
            }
        }
    }
    
    func updateExistingRoute(route: Route) {
        let existingRouteID = route.id  // サンプル UUID
        let updatedName = route.name
        let depotID = route.depot.id
        
        var cityIDs: [UUID] = []
        for city in route.cities {
            cityIDs.append(city.id)
        }
        var salesmanIDs: [UUID] = []
        for salesman in route.salesmen {
            salesmanIDs.append(salesman.id)
        }

        let updatedDescription = route.description

        APIClient.shared.updateRoute(
            routeID: existingRouteID,
            name: updatedName,
            depot: depotID,
            cities: Array(cityIDs),
            salesmen: Array(salesmanIDs),
            description: updatedDescription
        ) { success in
            if success {
                print("update route ok")
            }
        }
    }
    
    func deleteExistingRoute(deleteRouteID: UUID) {
        APIClient.shared.deleteRoute(routeID: deleteRouteID) { success in
            if success {
                self.routes.removeAll { $0.id == deleteRouteID }
            }
        }
    }
    
    func fetchAllCities() {
        APIClient.shared.fetchCities { fetchedCities in
            if let fetchedCities = fetchedCities {
                self.cities = fetchedCities
            }
        }
    }
    
    func createNewCity(city: City){
        let newCityName = city.name
        let address = city.address
        let salesmanID = city.salesman.id
        let description = city.description

        APIClient.shared.createCity(
            name: newCityName,
            address: address,
            salesman: salesmanID,
            description: description
        ) { success in
            if success {
                print("create city ok")
            }
        }
    }
    
    func updateExistingCity(city: City) {
        let existingCityID = city.id  // サンプル UUID
        let updatedName = city.name
        let address = city.address
        let salesmanID = city.salesman.id
        let updatedDescription = city.description

        APIClient.shared.updateCity(
            cityID: existingCityID,
            name: updatedName,
            address: address,
            salesman: salesmanID,
            description: updatedDescription
        ) { success in
            if success {
                print("update city ok")
            }
        }
    }
    
    func deleteExistingCity(deleteCityID: UUID) {
        APIClient.shared.deleteCity(cityID: deleteCityID) { success in
            if success {
                self.cities.removeAll { $0.id == deleteCityID }
            }
        }
    }
    
    func fetchAllSalesmen() {
        APIClient.shared.fetchSalesmen { fetchedSalesmen in
            if let fetchedSalesmen = fetchedSalesmen {
                self.salesmen = fetchedSalesmen
            }
        }
    }
    
    func createNewSalesman(salesman: Salesman){
        let newSalesmanName = salesman.name
        let description = salesman.description

        APIClient.shared.createSalesman(
            name: newSalesmanName,
            description: description
        ) { success in
            if success {
                print("create salesman ok")
            }
        }
    }
    
    func updateExistingSalesman(salesman: Salesman) {
        let existingSalesmanID = salesman.id  // サンプル UUID
        let updatedName = salesman.name
        let updatedDescription = salesman.description

        APIClient.shared.updateSalesman(
            salesmanID: existingSalesmanID,
            name: updatedName,
            description: updatedDescription
        ) { success in
            if success {
                print("update salesman ok")
            }
        }
    }
    
    func deleteExistingSalesman(deleteSalesmanID: UUID) {
        APIClient.shared.deleteSalesman(salesmanID: deleteSalesmanID) { success in
            if success {
                self.salesmen.removeAll { $0.id == deleteSalesmanID }
            }
        }
    }
    
    func fetchAllSolutions() {
        APIClient.shared.fetchSolutions { fetchedSolutions in
            if let fetchedSolutions = fetchedSolutions{
                self.solutions = fetchedSolutions
                for solution in self.solutions {
                    if self.currentRoute.id == solution.id {
                        self.currentSolution = solution
                        self.currentPathes = solution.path
                    }
                }
            }
        }
    }
    
    func loadData(for routeId: UUID) {
            guard let url = URL(string: "http://127.0.0.1:8000/api/res/\(routeId.uuidString.lowercased())/") else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }

                do {
                    struct ResponseData: Codable {
                        let html: String
                        let salesmen: [Salesman]
                        let pathes: [[String]]
                    }

                    let decoded = try JSONDecoder().decode(ResponseData.self, from: data)

                    DispatchQueue.main.async {
                        self.htmlContent = decoded.html
                        self.currentSalesmen = decoded.salesmen
                        self.currentPathes = decoded.pathes
                    }
                } catch {
                    print("デコードエラー: \(error)")
                }
            }.resume()
        }
    
    func fetchAllSolutionsToDetail(){
        APIClient.shared.fetchSolutions { fetchedSolutions in
            if let fetchedSolutions = fetchedSolutions {
                self.solutions = fetchedSolutions
            }
        }
    }
}
