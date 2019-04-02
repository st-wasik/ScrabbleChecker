#include "Application.h"



Application::Application() 
	: window{ sf::VideoMode(980, 980), "Scrable Czeker", sf::Style::Close },  gui {window},
		theme{ "../../ScrabbleCzeker/TGUI-0.8/themes/Black.txt" }
{
	font = tgui::Font("../../ScrabbleCzeker/TGUI-0.8/fonts/Amble-Bold.ttf");
}


Application::~Application()
{
}

void Application::run()
{
	srand(static_cast<unsigned int>(time(NULL)));

	shapes = buildBoard();

	addTile( L"K", 0, 0);
	addTile( L"O", 0, 1);
	addTile( L"L", 0, 2);
	addTile( L"Ê", 0, 3);
	addTile( L"D", 0, 4);
	addTile( L"A", 0, 5);

	while (window.isOpen())
	{
		sf::Event event;
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
				window.close();
			if (event.type == sf::Event::LostFocus)
				window.close();

			gui.handleEvent(event);
		}
		window.clear();
		for (int i = 0; i < shapes.size(); i++)
		{
			window.draw(shapes[i]);
		}
		gui.draw();
		window.display();
	}
}

std::vector<sf::RectangleShape> Application::buildBoard()
{
	std::vector<sf::RectangleShape> toBuild;

	t.loadFromFile("../ScrabbleCzeker/textures/noise.png");
	t.setRepeated(true);
	t.setSmooth(true);

	star.loadFromFile("../ScrabbleCzeker/textures/star.png");
	star.setRepeated(true);
	star.setSmooth(true);

	//Values meaning:
	//0 - normal field
	//1 - letter bonus - x2
	//2 - letter bonus - x3
	//3 - word bonus - x2
	//4 - word bonus - x3
	//5 - central field (starting point)
	std::vector<std::vector<int>> board =
	{
		{2,0,0,3,0,0,0,2,0,0,0,3,0,0,2},
		{0,1,0,0,0,4,0,0,0,4,0,0,0,1,0},
		{0,0,1,0,0,0,3,0,3,0,0,0,1,0,0},
		{0,0,0,1,0,0,0,3,0,0,0,1,0,0,0},
		{0,0,0,0,1,0,0,0,0,0,1,0,0,0,0},
		{0,4,0,0,0,4,0,0,0,4,0,0,0,4,0},
		{0,0,3,0,0,0,3,0,3,0,0,0,3,0,0},
		{2,0,0,3,0,0,0,5,0,0,0,3,0,0,2},
		{0,0,3,0,0,0,3,0,3,0,0,0,3,0,0},
		{0,4,0,0,0,4,0,0,0,4,0,0,0,4,0},
		{0,0,0,0,1,0,0,0,0,0,1,0,0,0,0},
		{0,0,0,1,0,0,0,3,0,0,0,1,0,0,0},
		{0,0,1,0,0,0,3,0,3,0,0,0,1,0,0},
		{0,1,0,0,0,4,0,0,0,4,0,0,0,1,0},
		{2,0,0,3,0,0,0,2,0,0,0,3,0,0,2}
	};
	sf::RectangleShape background(sf::Vector2f(980, 980));
	background.setFillColor(sf::Color::Black);
	toBuild.push_back(background);
	for (int i = 0; i < board.size(); i++)
	{
		for (int j = 0; j < board[i].size(); j++)
		{
			sf::RectangleShape field(sf::Vector2f(60, 60));
			field.setPosition((1.f + j) * 5 + j * 60, (1.f + i) * 5 + i * 60);
			switch (board[i][j])
			{
				case 0: 
					field.setFillColor(sf::Color(13, 132, 105));
					break;
				case 1:	
					field.setFillColor(sf::Color(246, 156, 156)); 
					break;
				case 2:	
					field.setFillColor(sf::Color(224, 65, 86)); 
					break;
				case 3:	
					field.setFillColor(sf::Color(144, 193, 211)); 
					break;
				case 4: 
					field.setFillColor(sf::Color(29, 124, 194)); 
					break;
				case 5:	
					field.setFillColor(sf::Color(223, 201, 202)); 
					break;
				default: 
					break;
			}


			// 54 is field size
			// 64 is the texture size (% 11 to get texture border coords)
			auto rnd = rand() % 11;
			auto rect = sf::IntRect(rnd + 0, rnd + 0, rnd + 10, rnd + 10);

			field.setTextureRect(rect);
			field.setTexture(&t);

			if (board[i][j] == 5)
			{
				field.setTextureRect(sf::IntRect(0, 0, 60, 60));
				field.setTexture(&star);
			}


			toBuild.push_back(field);
		}
	}
	return toBuild;
}

void Application::addTile(std::wstring letter, int x, int y)
{
	auto tile = tgui::Button::create();
	tile->setRenderer(theme.getRenderer("Button"));
	tile->setPosition((1 + y) * 5 + y * 60 + 3, (1 + x) * 5 + x * 60 + 3);
	tile->setText(letter);
	tile->setTextSize(38);
	tile->setSize(54, 54);
	tile->setEnabled(0);
	tile->setInheritedFont(font);
	gui.add(tile);
}



