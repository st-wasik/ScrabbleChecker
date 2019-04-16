#include "Application.h"


Application::Application() 
	: window{ sf::VideoMode(980, 980), "Scrable Czeker", sf::Style::Close },  board {window},
		theme{ "../../ScrabbleCzeker/TGUI-0.8/themes/CheckerThemas.txt" }
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

	//addTile(L"K", 7, 3, 'I');
	//addTile(L"O", 7, 4, 'P');
	//addTile(L"L", 7, 5);
	//addTile(L"Ê", 7, 6);
	//addTile(L"D", 7, 7);
	//addTile(L"A", 7, 8);
	//addTile(L"O", 8, 3);
	//addTile(L"T", 9, 3);
	//addTile(L"J", 5, 7);
	//addTile(L"E", 6, 7);
	//addTile(L"N", 8, 7);
	//addTile(L"A", 9, 7);
	//addTile(L"K", 10, 7);
	//addTile(L"¯", 11, 7);
	//addTile(L"E", 12, 7);
	//addTile(L"A", 1, 5);
	//addTile(L"L", 2, 5);
	//addTile(L"K", 3, 5);
	//addTile(L"O", 4, 5);
	//addTile(L"H", 5, 5);
	//addTile(L"O", 6, 5);
	//addTile(L"I", 2, 6);
	//addTile(L"Z", 2, 7);
	//addTile(L"A", 2, 8);
	//addTile(L"K", 2, 9);
	//addTile(L"J", 4, 2);
	//addTile(L"A", 4, 3);
	//addTile(L"J", 4, 4);
	//addTile(L"W", 12, 8);
	//addTile(L"A", 12, 9);
	//addTile(L"G", 8, 9);
	//addTile(L"R", 9, 9);
	//addTile(L"U", 10, 9);
	//addTile(L"B", 11, 9);
	//addTile(L"B", 10, 10);
	//addTile(L"A", 10, 11);
	//addTile(L"W", 10, 12);

	while (window.isOpen())
	{
		sf::Event event;
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
				window.close();
			//if (event.type == sf::Event::LostFocus)
				//window.close();

			board.handleEvent(event);
		}
		window.clear();
		for (int i = 0; i < shapes.size(); i++)
		{
			window.draw(shapes[i]);
		}
		board.draw();
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

	//Meaning of values:
	//0 - normal field
	//1 - letter bonus - x2
	//2 - letter bonus - x3
	//3 - word bonus - x2
	//4 - word bonus - x3
	//5 - central field (starting point)
	std::vector<std::vector<int>> boardVec =
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
	background.setFillColor(sf::Color(32,32,32,255));
	toBuild.push_back(background);
	for (int i = 0; i < boardVec.size(); i++)
	{
		for (int j = 0; j < boardVec[i].size(); j++)
		{
			sf::RectangleShape field(sf::Vector2f(60, 60));
			field.setPosition((1.f + j) * 5 + j * 60, (1.f + i) * 5 + i * 60);
			switch (boardVec[i][j])
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


			// 60 is field size
			// 64 is the texture size (% 11 to get texture border coords)
			auto rnd = rand() % 11;
			auto rect = sf::IntRect(rnd + 0, rnd + 0, rnd + 10, rnd + 10);

			field.setTextureRect(rect);
			field.setTexture(&t);

			if (boardVec[i][j] == 5)
			{
				field.setTextureRect(sf::IntRect(0, 0, 60, 60));
				field.setTexture(&star);
			}


			toBuild.push_back(field);
		}
	}
	return toBuild;
}

void Application::addTile(const wchar_t *l, int x, int y, char status)
{
	//field size is 60x60
	//tile size is 54x54
	//with this we can see field color (type) under tile
	auto tile = tgui::Button::create();
	if(status=='V')
		tile->setRenderer(theme.getRenderer("ButtonValid"));
	if(status=='I')
		tile->setRenderer(theme.getRenderer("ButtonInvalid"));
	if(status=='P')
		tile->setRenderer(theme.getRenderer("ButtonPartOfIn"));
	tile->setPosition((1 + y) * 5 + y * 60 + 3, (1 + x) * 5 + x * 60 + 3);
	tile->setText(l);
	tile->setTextSize(38);
	tile->setSize(54, 54);
	tile->setEnabled(0);
	tile->setInheritedFont(font);
	board.add(tile);

	letter var;
	var.chr = l;
	var.status = status;
	var.tile = tile;
	tiles[x][y] = var;
}

void Application::clearInvalid()
{
	for (int i = 0; i < 15; i++)
		for (int j = 0; j < 15; j++)
		{
			if (tiles[i][j].status == 'I')
			{
				board.remove(tiles[i][j].tile);
				tiles[i][j].chr = nullptr;
				tiles[i][j].tile = nullptr;
				tiles[i][j].status = 'B';
			}
			if (tiles[i][j].status == 'P')
			{
				tiles[i][j].tile->setRenderer(theme.getRenderer("ButtonValid"));
				tiles[i][j].status = 'V';
			}
		}
}

