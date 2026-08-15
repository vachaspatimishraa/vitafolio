/// Data models for compiled-in hardcoded location hierarchy.
class LocationCountry {
  final String name;
  final List<LocationState> states;

  const LocationCountry({
    required this.name,
    required this.states,
  });
}

class LocationState {
  final String name;
  final List<String> cities;

  const LocationState({
    required this.name,
    required this.cities,
  });
}

/// Comprehensive compiled-in global location catalogue transcribed from global_cities_data.md.
const List<LocationCountry> kGlobalLocationCatalogue = [
  LocationCountry(
    name: 'India',
    states: [
      LocationState(
        name: 'Andhra Pradesh',
        cities: [
          'Visakhapatnam',
          'Vijayawada',
          'Guntur',
          'Nellore',
          'Tirupati',
          'Kurnool',
          'Kakinada',
          'Rajahmundry',
          'Kadapa',
          'Anantapur',
        ],
      ),
      LocationState(
        name: 'Arunachal Pradesh',
        cities: [
          'Itanagar',
          'Tawang',
          'Naharlagun',
          'Pasighat',
          'Roing',
          'Tezu',
          'Bomdila',
        ],
      ),
      LocationState(
        name: 'Assam',
        cities: [
          'Guwahati',
          'Silchar',
          'Dibrugarh',
          'Jorhat',
          'Nagaon',
          'Tinsukia',
          'Tezpur',
        ],
      ),
      LocationState(
        name: 'Bihar',
        cities: [
          'Patna',
          'Gaya',
          'Bhagalpur',
          'Muzaffarpur',
          'Purnia',
          'Darbhanga',
          'Bihar Sharif',
          'Ara',
        ],
      ),
      LocationState(
        name: 'Chhattisgarh',
        cities: [
          'Raipur',
          'Bhilai',
          'Bilaspur',
          'Korba',
          'Rajnandgaon',
          'Raigarh',
          'Jagdalpur',
          'Ambikapur',
        ],
      ),
      LocationState(
        name: 'Goa',
        cities: [
          'Panaji',
          'Vasco da Gama',
          'Margao',
          'Mapusa',
          'Ponda',
        ],
      ),
      LocationState(
        name: 'Gujarat',
        cities: [
          'Ahmedabad',
          'Surat',
          'Vadodara',
          'Rajkot',
          'Bhavnagar',
          'Jamnagar',
          'Gandhinagar',
          'Junagadh',
        ],
      ),
      LocationState(
        name: 'Haryana',
        cities: [
          'Faridabad',
          'Gurugram',
          'Panipat',
          'Ambala',
          'Yamunanagar',
          'Rohtak',
          'Hisar',
          'Karnal',
          'Panchkula',
        ],
      ),
      LocationState(
        name: 'Himachal Pradesh',
        cities: [
          'Shimla',
          'Mandi',
          'Dharamshala',
          'Solan',
          'Palampur',
          'Kullu',
          'Chamba',
          'Una',
        ],
      ),
      LocationState(
        name: 'Jharkhand',
        cities: [
          'Ranchi',
          'Jamshedpur',
          'Dhanbad',
          'Bokaro',
          'Deoghar',
          'Hazaribagh',
          'Giridih',
        ],
      ),
      LocationState(
        name: 'Karnataka',
        cities: [
          'Bengaluru',
          'Mysuru',
          'Hubballi-Dharwad',
          'Mangaluru',
          'Belagavi',
          'Davangere',
          'Ballari',
          'Kalaburagi',
          'Udupi',
        ],
      ),
      LocationState(
        name: 'Kerala',
        cities: [
          'Thiruvananthapuram',
          'Kochi',
          'Kozhikode',
          'Thrissur',
          'Kollam',
          'Alappuzha',
          'Palakkad',
          'Kannur',
          'Kottayam',
        ],
      ),
      LocationState(
        name: 'Madhya Pradesh',
        cities: [
          'Indore',
          'Bhopal',
          'Jabalpur',
          'Gwalior',
          'Ujjain',
          'Sagar',
          'Dewas',
          'Satna',
          'Ratlam',
          'Rewa',
        ],
      ),
      LocationState(
        name: 'Maharashtra',
        cities: [
          'Mumbai',
          'Pune',
          'Nagpur',
          'Thane',
          'Nashik',
          'Kalyan-Dombivli',
          'Vasai-Virar',
          'Aurangabad',
          'Navi Mumbai',
          'Solapur',
          'Amravati',
          'Kolhapur',
        ],
      ),
      LocationState(
        name: 'Manipur',
        cities: [
          'Imphal',
          'Churachandpur',
          'Thoubal',
          'Kakching',
          'Senapati',
        ],
      ),
      LocationState(
        name: 'Meghalaya',
        cities: [
          'Shillong',
          'Tura',
          'Nongstoin',
          'Jowai',
          'Baghmara',
        ],
      ),
      LocationState(
        name: 'Mizoram',
        cities: [
          'Aizawl',
          'Lunglei',
          'Saiha',
          'Champhai',
          'Kolasib',
        ],
      ),
      LocationState(
        name: 'Nagaland',
        cities: [
          'Dimapur',
          'Kohima',
          'Mokokchung',
          'Tuensang',
          'Wokha',
        ],
      ),
      LocationState(
        name: 'Odisha',
        cities: [
          'Bhubaneswar',
          'Cuttack',
          'Rourkela',
          'Brahmapur',
          'Sambalpur',
          'Puri',
          'Balasore',
          'Bhadrak',
          'Baripada',
        ],
      ),
      LocationState(
        name: 'Punjab',
        cities: [
          'Ludhiana',
          'Amritsar',
          'Jalandhar',
          'Patiala',
          'Bathinda',
          'Mohali',
          'Pathankot',
          'Moga',
        ],
      ),
      LocationState(
        name: 'Rajasthan',
        cities: [
          'Jaipur',
          'Jodhpur',
          'Kota',
          'Bikaner',
          'Ajmer',
          'Udaipur',
          'Bhilwara',
          'Alwar',
          'Bharatpur',
          'Sikar',
        ],
      ),
      LocationState(
        name: 'Sikkim',
        cities: [
          'Gangtok',
          'Namchi',
          'Gyalshing',
          'Mangan',
        ],
      ),
      LocationState(
        name: 'Tamil Nadu',
        cities: [
          'Chennai',
          'Coimbatore',
          'Madurai',
          'Tiruchirappalli',
          'Salem',
          'Tirunelveli',
          'Tiruppur',
          'Vellore',
          'Erode',
          'Thoothukudi',
        ],
      ),
      LocationState(
        name: 'Telangana',
        cities: [
          'Hyderabad',
          'Warangal',
          'Nizamabad',
          'Karimnagar',
          'Ramagundam',
          'Khammam',
          'Mahbubnagar',
          'Nalgonda',
        ],
      ),
      LocationState(
        name: 'Tripura',
        cities: [
          'Agartala',
          'Dharmanagar',
          'Udaipur',
          'Kailashahar',
          'Bishalgarh',
        ],
      ),
      LocationState(
        name: 'Uttar Pradesh',
        cities: [
          'Lucknow',
          'Kanpur',
          'Ghaziabad',
          'Agra',
          'Varanasi',
          'Meerut',
          'Prayagraj',
          'Bareilly',
          'Aligarh',
          'Moradabad',
          'Saharanpur',
          'Gorakhpur',
          'Noida',
          'Mathura',
        ],
      ),
      LocationState(
        name: 'Uttarakhand',
        cities: [
          'Dehradun',
          'Haridwar',
          'Roorkee',
          'Haldwani',
          'Rudrapur',
          'Kashipur',
          'Rishikesh',
        ],
      ),
      LocationState(
        name: 'West Bengal',
        cities: [
          'Kolkata',
          'Asansol',
          'Siliguri',
          'Durgapur',
          'Bardhaman',
          'Malda',
          'Baharampur',
          'Habra',
          'Kharagpur',
          'Haldia',
        ],
      ),
      LocationState(
        name: 'Andaman and Nicobar Islands',
        cities: ['Port Blair', 'Diglipur', 'Mayabunder'],
      ),
      LocationState(
        name: 'Chandigarh',
        cities: ['Chandigarh'],
      ),
      LocationState(
        name: 'Dadra and Nagar Haveli and Daman and Diu',
        cities: ['Daman', 'Diu', 'Silvassa', 'Amli'],
      ),
      LocationState(
        name: 'Lakshadweep',
        cities: ['Kavaratti', 'Agatti', 'Amini', 'Minicoy'],
      ),
      LocationState(
        name: 'Delhi',
        cities: [
          'New Delhi',
          'North Delhi',
          'South Delhi',
          'East Delhi',
          'West Delhi',
        ],
      ),
      LocationState(
        name: 'Puducherry',
        cities: ['Puducherry', 'Oulgaret', 'Karaikal', 'Yanam', 'Mahe'],
      ),
      LocationState(
        name: 'Jammu and Kashmir',
        cities: ['Srinagar', 'Jammu', 'Anantnag', 'Baramulla', 'Kathua', 'Sopore'],
      ),
      LocationState(
        name: 'Ladakh',
        cities: ['Leh', 'Kargil'],
      ),
    ],
  ),
  LocationCountry(
    name: 'United States',
    states: [
      LocationState(
        name: 'California',
        cities: ['Los Angeles', 'San Francisco', 'San Diego'],
      ),
      LocationState(
        name: 'Texas',
        cities: ['Houston', 'Austin', 'Dallas'],
      ),
      LocationState(
        name: 'New York',
        cities: ['New York City', 'Buffalo', 'Albany'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Canada',
    states: [
      LocationState(
        name: 'Ontario',
        cities: ['Toronto', 'Ottawa', 'Mississauga'],
      ),
      LocationState(
        name: 'Quebec',
        cities: ['Montreal', 'Quebec City', 'Laval'],
      ),
      LocationState(
        name: 'British Columbia',
        cities: ['Vancouver', 'Victoria', 'Surrey'],
      ),
    ],
  ),
  LocationCountry(
    name: 'United Kingdom',
    states: [
      LocationState(
        name: 'England',
        cities: ['London', 'Manchester', 'Birmingham'],
      ),
      LocationState(
        name: 'Scotland',
        cities: ['Edinburgh', 'Glasgow', 'Aberdeen'],
      ),
      LocationState(
        name: 'Wales',
        cities: ['Cardiff', 'Swansea', 'Newport'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Australia',
    states: [
      LocationState(
        name: 'New South Wales',
        cities: ['Sydney', 'Newcastle', 'Wollongong'],
      ),
      LocationState(
        name: 'Victoria',
        cities: ['Melbourne', 'Geelong', 'Ballarat'],
      ),
      LocationState(
        name: 'Queensland',
        cities: ['Brisbane', 'Gold Coast', 'Cairns'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Germany',
    states: [
      LocationState(
        name: 'Bavaria',
        cities: ['Munich', 'Nuremberg', 'Augsburg'],
      ),
      LocationState(
        name: 'Berlin',
        cities: ['Berlin'],
      ),
      LocationState(
        name: 'North Rhine-Westphalia',
        cities: ['Cologne', 'Düsseldorf', 'Dortmund'],
      ),
    ],
  ),
  LocationCountry(
    name: 'France',
    states: [
      LocationState(
        name: 'Île-de-France',
        cities: ['Paris', 'Versailles'],
      ),
      LocationState(
        name: "Provence-Alpes-Côte d'Azur",
        cities: ['Marseille', 'Nice', 'Cannes'],
      ),
      LocationState(
        name: 'Auvergne-Rhône-Alpes',
        cities: ['Lyon', 'Grenoble', 'Annecy'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Italy',
    states: [
      LocationState(
        name: 'Lombardy',
        cities: ['Milan', 'Bergamo', 'Brescia'],
      ),
      LocationState(
        name: 'Lazio',
        cities: ['Rome', 'Latina'],
      ),
      LocationState(
        name: 'Campania',
        cities: ['Naples', 'Salerno'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Spain',
    states: [
      LocationState(
        name: 'Catalonia',
        cities: ['Barcelona', 'Girona'],
      ),
      LocationState(
        name: 'Madrid',
        cities: ['Madrid', 'Getafe'],
      ),
      LocationState(
        name: 'Andalusia',
        cities: ['Seville', 'Málaga', 'Granada'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Japan',
    states: [
      LocationState(
        name: 'Tokyo',
        cities: ['Tokyo', 'Hachioji'],
      ),
      LocationState(
        name: 'Osaka',
        cities: ['Osaka', 'Sakai'],
      ),
      LocationState(
        name: 'Kyoto',
        cities: ['Kyoto', 'Uji'],
      ),
    ],
  ),
  LocationCountry(
    name: 'China',
    states: [
      LocationState(
        name: 'Guangdong',
        cities: ['Guangzhou', 'Shenzhen', 'Dongguan'],
      ),
      LocationState(
        name: 'Zhejiang',
        cities: ['Hangzhou', 'Ningbo'],
      ),
      LocationState(
        name: 'Sichuan',
        cities: ['Chengdu', 'Mianyang'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Brazil',
    states: [
      LocationState(
        name: 'São Paulo',
        cities: ['São Paulo', 'Campinas'],
      ),
      LocationState(
        name: 'Rio de Janeiro',
        cities: ['Rio de Janeiro', 'Niterói'],
      ),
      LocationState(
        name: 'Minas Gerais',
        cities: ['Belo Horizonte', 'Uberlândia'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Mexico',
    states: [
      LocationState(
        name: 'Jalisco',
        cities: ['Guadalajara', 'Puerto Vallarta'],
      ),
      LocationState(
        name: 'Nuevo León',
        cities: ['Monterrey', 'San Pedro Garza García'],
      ),
      LocationState(
        name: 'Mexico City',
        cities: ['Mexico City'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Russia',
    states: [
      LocationState(
        name: 'Moscow',
        cities: ['Moscow', 'Zelenograd'],
      ),
      LocationState(
        name: 'Saint Petersburg',
        cities: ['Saint Petersburg'],
      ),
      LocationState(
        name: 'Novosibirsk Oblast',
        cities: ['Novosibirsk', 'Berdsk'],
      ),
    ],
  ),
  LocationCountry(
    name: 'South Africa',
    states: [
      LocationState(
        name: 'Gauteng',
        cities: ['Johannesburg', 'Pretoria'],
      ),
      LocationState(
        name: 'Western Cape',
        cities: ['Cape Town', 'Stellenbosch'],
      ),
      LocationState(
        name: 'KwaZulu-Natal',
        cities: ['Durban', 'Pietermaritzburg'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Argentina',
    states: [
      LocationState(
        name: 'Buenos Aires',
        cities: ['La Plata', 'Mar del Plata'],
      ),
      LocationState(
        name: 'Córdoba',
        cities: ['Córdoba', 'Villa Carlos Paz'],
      ),
      LocationState(
        name: 'Santa Fe',
        cities: ['Rosario', 'Santa Fe'],
      ),
    ],
  ),
  LocationCountry(
    name: 'New Zealand',
    states: [
      LocationState(
        name: 'Auckland',
        cities: ['Auckland'],
      ),
      LocationState(
        name: 'Wellington',
        cities: ['Wellington', 'Lower Hutt'],
      ),
      LocationState(
        name: 'Canterbury',
        cities: ['Christchurch', 'Timaru'],
      ),
    ],
  ),
  LocationCountry(
    name: 'South Korea',
    states: [
      LocationState(
        name: 'Gyeonggi',
        cities: ['Suwon', 'Seongnam'],
      ),
      LocationState(
        name: 'Seoul',
        cities: ['Seoul'],
      ),
      LocationState(
        name: 'Busan',
        cities: ['Busan'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Egypt',
    states: [
      LocationState(
        name: 'Cairo',
        cities: ['Cairo'],
      ),
      LocationState(
        name: 'Alexandria',
        cities: ['Alexandria'],
      ),
      LocationState(
        name: 'Giza',
        cities: ['Giza'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Nigeria',
    states: [
      LocationState(
        name: 'Lagos',
        cities: ['Lagos', 'Ikeja'],
      ),
      LocationState(
        name: 'Kano',
        cities: ['Kano'],
      ),
      LocationState(
        name: 'Rivers',
        cities: ['Port Harcourt'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Kenya',
    states: [
      LocationState(
        name: 'Nairobi',
        cities: ['Nairobi'],
      ),
      LocationState(
        name: 'Mombasa',
        cities: ['Mombasa'],
      ),
      LocationState(
        name: 'Kisumu',
        cities: ['Kisumu'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Saudi Arabia',
    states: [
      LocationState(
        name: 'Riyadh',
        cities: ['Riyadh'],
      ),
      LocationState(
        name: 'Makkah',
        cities: ['Mecca', 'Jeddah'],
      ),
      LocationState(
        name: 'Eastern Province',
        cities: ['Dammam', 'Khobar'],
      ),
    ],
  ),
  LocationCountry(
    name: 'United Arab Emirates',
    states: [
      LocationState(
        name: 'Dubai',
        cities: ['Dubai'],
      ),
      LocationState(
        name: 'Abu Dhabi',
        cities: ['Abu Dhabi', 'Al Ain'],
      ),
      LocationState(
        name: 'Sharjah',
        cities: ['Sharjah'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Turkey',
    states: [
      LocationState(
        name: 'Istanbul',
        cities: ['Istanbul'],
      ),
      LocationState(
        name: 'Ankara',
        cities: ['Ankara'],
      ),
      LocationState(
        name: 'Izmir',
        cities: ['Izmir'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Iran',
    states: [
      LocationState(
        name: 'Tehran',
        cities: ['Tehran'],
      ),
      LocationState(
        name: 'Razavi Khorasan',
        cities: ['Mashhad'],
      ),
      LocationState(
        name: 'Isfahan',
        cities: ['Isfahan'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Thailand',
    states: [
      LocationState(
        name: 'Bangkok',
        cities: ['Bangkok'],
      ),
      LocationState(
        name: 'Chiang Mai',
        cities: ['Chiang Mai', 'Fang'],
      ),
      LocationState(
        name: 'Phuket',
        cities: ['Phuket'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Vietnam',
    states: [
      LocationState(
        name: 'Ho Chi Minh City',
        cities: ['Ho Chi Minh City'],
      ),
      LocationState(
        name: 'Hanoi',
        cities: ['Hanoi'],
      ),
      LocationState(
        name: 'Da Nang',
        cities: ['Da Nang'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Malaysia',
    states: [
      LocationState(
        name: 'Selangor',
        cities: ['Klang', 'Petaling Jaya'],
      ),
      LocationState(
        name: 'Kuala Lumpur',
        cities: ['Kuala Lumpur'],
      ),
      LocationState(
        name: 'Penang',
        cities: ['George Town'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Singapore',
    states: [
      LocationState(
        name: 'Singapore',
        cities: ['Singapore'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Indonesia',
    states: [
      LocationState(
        name: 'Jakarta',
        cities: ['Jakarta'],
      ),
      LocationState(
        name: 'West Java',
        cities: ['Bandung', 'Bogor'],
      ),
      LocationState(
        name: 'East Java',
        cities: ['Surabaya', 'Malang'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Philippines',
    states: [
      LocationState(
        name: 'Metro Manila',
        cities: ['Manila', 'Quezon City', 'Makati'],
      ),
      LocationState(
        name: 'Cebu',
        cities: ['Cebu City', 'Lapu-Lapu'],
      ),
      LocationState(
        name: 'Davao',
        cities: ['Davao City'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Pakistan',
    states: [
      LocationState(
        name: 'Punjab',
        cities: ['Lahore', 'Faisalabad'],
      ),
      LocationState(
        name: 'Sindh',
        cities: ['Karachi', 'Hyderabad'],
      ),
      LocationState(
        name: 'Khyber Pakhtunkhwa',
        cities: ['Peshawar'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Bangladesh',
    states: [
      LocationState(
        name: 'Dhaka',
        cities: ['Dhaka', 'Gazipur'],
      ),
      LocationState(
        name: 'Chittagong',
        cities: ['Chittagong', "Cox's Bazar"],
      ),
      LocationState(
        name: 'Sylhet',
        cities: ['Sylhet'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Sri Lanka',
    states: [
      LocationState(
        name: 'Western Province',
        cities: ['Colombo', 'Negombo'],
      ),
      LocationState(
        name: 'Central Province',
        cities: ['Kandy'],
      ),
      LocationState(
        name: 'Southern Province',
        cities: ['Galle'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Nepal',
    states: [
      LocationState(
        name: 'Bagmati',
        cities: ['Kathmandu', 'Lalitpur'],
      ),
      LocationState(
        name: 'Gandaki',
        cities: ['Pokhara'],
      ),
      LocationState(
        name: 'Lumbini',
        cities: ['Butwal'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Afghanistan',
    states: [
      LocationState(
        name: 'Kabul',
        cities: ['Kabul'],
      ),
      LocationState(
        name: 'Herat',
        cities: ['Herat'],
      ),
      LocationState(
        name: 'Balkh',
        cities: ['Mazar-i-Sharif'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Iraq',
    states: [
      LocationState(
        name: 'Baghdad',
        cities: ['Baghdad'],
      ),
      LocationState(
        name: 'Basra',
        cities: ['Basra'],
      ),
      LocationState(
        name: 'Erbil',
        cities: ['Erbil'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Israel',
    states: [
      LocationState(
        name: 'Tel Aviv',
        cities: ['Tel Aviv', 'Ramat Gan'],
      ),
      LocationState(
        name: 'Jerusalem',
        cities: ['Jerusalem'],
      ),
      LocationState(
        name: 'Haifa',
        cities: ['Haifa'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Sweden',
    states: [
      LocationState(
        name: 'Stockholm',
        cities: ['Stockholm'],
      ),
      LocationState(
        name: 'Västra Götaland',
        cities: ['Gothenburg'],
      ),
      LocationState(
        name: 'Skåne',
        cities: ['Malmö'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Norway',
    states: [
      LocationState(
        name: 'Oslo',
        cities: ['Oslo'],
      ),
      LocationState(
        name: 'Vestland',
        cities: ['Bergen'],
      ),
      LocationState(
        name: 'Trøndelag',
        cities: ['Trondheim'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Denmark',
    states: [
      LocationState(
        name: 'Capital Region',
        cities: ['Copenhagen'],
      ),
      LocationState(
        name: 'Central Denmark',
        cities: ['Aarhus'],
      ),
      LocationState(
        name: 'Southern Denmark',
        cities: ['Odense'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Finland',
    states: [
      LocationState(
        name: 'Uusimaa',
        cities: ['Helsinki', 'Espoo'],
      ),
      LocationState(
        name: 'Pirkanmaa',
        cities: ['Tampere'],
      ),
      LocationState(
        name: 'Southwest Finland',
        cities: ['Turku'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Netherlands',
    states: [
      LocationState(
        name: 'North Holland',
        cities: ['Amsterdam', 'Haarlem'],
      ),
      LocationState(
        name: 'South Holland',
        cities: ['Rotterdam', 'The Hague'],
      ),
      LocationState(
        name: 'Utrecht',
        cities: ['Utrecht'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Belgium',
    states: [
      LocationState(
        name: 'Brussels',
        cities: ['Brussels'],
      ),
      LocationState(
        name: 'Flanders',
        cities: ['Antwerp', 'Ghent'],
      ),
      LocationState(
        name: 'Wallonia',
        cities: ['Charleroi', 'Liège'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Switzerland',
    states: [
      LocationState(
        name: 'Zurich',
        cities: ['Zurich', 'Winterthur'],
      ),
      LocationState(
        name: 'Geneva',
        cities: ['Geneva'],
      ),
      LocationState(
        name: 'Vaud',
        cities: ['Lausanne'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Austria',
    states: [
      LocationState(
        name: 'Vienna',
        cities: ['Vienna'],
      ),
      LocationState(
        name: 'Styria',
        cities: ['Graz'],
      ),
      LocationState(
        name: 'Upper Austria',
        cities: ['Linz'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Greece',
    states: [
      LocationState(
        name: 'Attica',
        cities: ['Athens', 'Piraeus'],
      ),
      LocationState(
        name: 'Central Macedonia',
        cities: ['Thessaloniki'],
      ),
      LocationState(
        name: 'Crete',
        cities: ['Heraklion'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Portugal',
    states: [
      LocationState(
        name: 'Lisbon',
        cities: ['Lisbon', 'Sintra'],
      ),
      LocationState(
        name: 'Porto',
        cities: ['Porto', 'Vila Nova de Gaia'],
      ),
      LocationState(
        name: 'Braga',
        cities: ['Braga'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Ireland',
    states: [
      LocationState(
        name: 'Leinster',
        cities: ['Dublin'],
      ),
      LocationState(
        name: 'Munster',
        cities: ['Cork', 'Limerick'],
      ),
      LocationState(
        name: 'Connacht',
        cities: ['Galway'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Poland',
    states: [
      LocationState(
        name: 'Masovia',
        cities: ['Warsaw', 'Radom'],
      ),
      LocationState(
        name: 'Lesser Poland',
        cities: ['Kraków'],
      ),
      LocationState(
        name: 'Greater Poland',
        cities: ['Poznań'],
      ),
    ],
  ),
  LocationCountry(
    name: 'Ukraine',
    states: [
      LocationState(
        name: 'Kyiv',
        cities: ['Kyiv'],
      ),
      LocationState(
        name: 'Kharkiv',
        cities: ['Kharkiv'],
      ),
      LocationState(
        name: 'Lviv',
        cities: ['Lviv'],
      ),
    ],
  ),
];
