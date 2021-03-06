#include "Application.h"
#include <iostream>
#include <algorithm>
#include <regex>
#include <thread>
#include <mutex>

std::vector<sf::RectangleShape> Application::buildBoard()
{
	std::vector<sf::RectangleShape> toBuild;

#ifdef RELEASE
	t.loadFromFile("../../ScrabbleCzeker/textures/noise.png");
	star.loadFromFile("../../ScrabbleCzeker/textures/star.png");
#else
	t.loadFromFile("../ScrabbleCzeker/textures/noise.png");
	star.loadFromFile("../ScrabbleCzeker/textures/star.png");
#endif

	t.setRepeated(true);
	t.setSmooth(true);

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
	background.setFillColor(sf::Color(32, 32, 32, 255));
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

void Application::addTile(int l, int x, int y, char status)
{
	//field size is 60x60
	//tile size is 54x54
	//with this we can see field color (type) under tile

	auto tile = tgui::Button::create();
	if (status == 'v')
		tile->setRenderer(theme.getRenderer("ButtonValid"));
	if (status == 'i')
		tile->setRenderer(theme.getRenderer("ButtonInvalid"));
	if (status == 'p')
		tile->setRenderer(theme.getRenderer("ButtonPartOfIn"));
	tile->setPosition((1 + y) * 5 + y * 60 + 3, (1 + x) * 5 + x * 60 + 3);
	tile->setText(wchar_t(l));
	tile->setTextSize(38);
	tile->setSize(54, 54);
	tile->setEnabled(0);
	tile->setInheritedFont(font);

	std::lock_guard<std::mutex> lock(mutex);
	board.add(tile);

	letter var;
	var.status = status;
	var.tile = tile;
	tiles[x][y] = var;
}

void Application::clear()
{
	//Statuses:
	//V-Valid
	//I-Invalid
	//P-PartOfInvalid
	//B-Blank

	std::lock_guard<std::mutex> lock(mutex);
	for (int i = 0; i < 15; i++)
		for (int j = 0; j < 15; j++)
		{
			board.remove(tiles[i][j].tile);
			tiles[i][j].tile.reset();
			tiles[i][j].status = 'B';
		}
}

void Application::read_words()
{
	//this file is saved with cp1250 encoding

	std::regex wordR(R"([a-z����󜟿]+)");
	std::regex numberR(R"(\d+)");

	std::regex pair(R"(\([a-z����󜟿]+,\d+\))");

	std::string result;

	std::cin >> result;
	auto words_begin = std::sregex_iterator(result.begin(), result.end(), pair);

	for (auto it = words_begin; it != std::sregex_iterator(); it++)
	{
		auto res_str = it->str();
		auto word = std::sregex_iterator(res_str.begin(), res_str.end(), wordR);
		auto number = std::sregex_iterator(res_str.begin(), res_str.end(), numberR);

		if (word != std::sregex_iterator() && number != std::sregex_iterator())
		{
			sf::String wordToUpper = word->str();
			for (auto& c : wordToUpper) c = convertCharacter(c & 0xFF);
			std::transform(wordToUpper.begin(), wordToUpper.end(), wordToUpper.begin(), ::toupper);
			sf::String item = wordToUpper + " \t" + number->str();

			std::lock_guard<std::mutex> lock(mutex);
			wordList->addItem(item);
		}
	}
}

void Application::read_stream()
{
	int countery = 0, counterx = 0;
	std::string stream;
	std::cin >> stream;
	if (std::cin.fail() || stream.empty())
	{
		std::cin.clear();
		return;
	}
	clear();

	if (stream == "exit")
	{
		close = true;
		return;
	}

	for (int i = 1; i < stream.size(); i++)
	{
		if (stream[i] == ']')
			break;
		else
		{
			if (stream[i] != ',')
			{
				if (stream[i] != '_')
				{
					//wchar_t letter;
					//std::mbtowc(&letter, &stream[i], 10);
					
					//addTile(letter, counterx, countery, stream[i + 1]);
					addTile(convertCharacter(((unsigned int)stream[i]) & 0xFF) , counterx, countery, stream[i + 1]);
				}
				countery++;
				if (countery > 14)
				{
					counterx++;
					countery = 0;
				}
				i++;
			}
		}
	}
	read_words();
}

int Application::convertCharacter(int value)
{
	switch (value)
	{
		// 1250 to Unicode
	case 165: return 260; break; //�
	case 198: return 262; break; //�
	case 202: return 280; break; //�
	case 163: return 321; break; //�
	case 209: return 323; break; //�
	case 221: return 211; break; //�
	case 140: return 346; break; //�
	case 143: return 377; break; //�
	case 175: return 379; break; //�

	//	//lower to lower
	//case 185: return 261; break; //�
	//case 230: return 263; break; //�
	//case 234: return 281; break; //�
	//case 179: return 322; break; //�
	//case 241: return 324; break; //�
	//case 243: return 243; break; //�
	//case 156: return 347; break; //�
	//case 159: return 378; break; //�
	//case 191: return 380; break; //�

		//lower to upper
	case 185: return 260; break; //�
	case 230: return 262; break; //�
	case 234: return 280; break; //�
	case 179: return 321; break; //�
	case 241: return 323; break; //�
	case 243: return 211; break; //�
	case 156: return 346; break; //�
	case 159: return 377; break; //�
	case 191: return 379; break; //�

	default: return value; break;
	}
}

std::shared_ptr<tgui::ListBox> Application::createList()
{
	auto label = tgui::Label::create();
	label->setRenderer(theme.getRenderer("ToolTip"));
	label->setText("\t\t\tWords");
	label->setPosition(980, 0);
	label->setSize(300, 50);
	label->setTextSize(32);
	label->setInheritedFont(font);
	board.add(label);

	std::shared_ptr<tgui::ListBox> listBox = tgui::ListBox::create();
	listBox->setRenderer(theme.getRenderer("ListBox"));
	listBox->setSize(300, 930);
	listBox->setItemHeight(36);
	listBox->setTextSize(28);
	listBox->setPosition(980, 50);
	listBox->setInheritedFont(font);


	board.add(listBox);

	return listBox;
}

#ifdef RELEASE
Application::Application()
	: window{ sf::VideoMode(1280, 980), "Scrable Czeker", sf::Style::Close }, board{ window },
	theme{ "../../TGUI-0.8/themes/CheckerThemas.txt" },
	close(false)
{
	font = tgui::Font("../../TGUI-0.8/fonts/Amble-Bold.ttf");
	window.setVerticalSyncEnabled(true);
	window.setFramerateLimit(60);
}
#else
Application::Application()
	: window{ sf::VideoMode(1280, 980), "Scrable Czeker", sf::Style::Close }, board{ window },
	theme{ "../../ScrabbleCzeker/TGUI-0.8/themes/CheckerThemas.txt" },
	close(false)
{
	font = tgui::Font("../../ScrabbleCzeker/TGUI-0.8/fonts/Amble-Bold.ttf");
}
#endif


Application::~Application()
{
}

void Application::run()
{
	srand(static_cast<unsigned int>(time(NULL)));

	shapes = buildBoard();

	wordList = createList();

	std::thread readDataThread([this]() {
		int x = 0;
		while (true)
		{
			this->read_stream();
		}
	});

	while (window.isOpen() && !close)
	{
		sf::Event event;
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
				window.close();

			std::lock_guard<std::mutex> lock(mutex);
			board.handleEvent(event);
		}

		{
			std::lock_guard<std::mutex> lock(mutex);
			window.clear();
			for (int i = 0; i < shapes.size(); i++)
			{
				window.draw(shapes[i]);
			}
			board.draw();
		}

		window.display();
	}
	close = true;
	readDataThread.detach();
}

