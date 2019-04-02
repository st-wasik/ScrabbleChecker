#include <SFML/Graphics.hpp>
#include <TGUI/TGUI.hpp>
#include <vector>

sf::Texture t, star;

std::vector<sf::RectangleShape> buildBoard(sf::RenderWindow &window)
{
	std::vector<sf::RectangleShape> toBuild;

	t.loadFromFile("../ScrabbleCzeker/textures/noise.png");
	t.setRepeated(true);
	t.setSmooth(true);

	star.loadFromFile("../ScrabbleCzeker/textures/star.png");
	star.setRepeated(true);
	star.setSmooth(true);

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
			field.setPosition((1 + j) * 5 + j * 60, (1 + i) * 5 + i * 60);
			if (board[i][j] == 0)
			field.setFillColor(sf::Color(13,132,105));
			if (board[i][j] == 1)
			field.setFillColor(sf::Color(246,156,156));
			if (board[i][j] == 2)
			field.setFillColor(sf::Color(224,65,86));
			if (board[i][j] == 3)
			field.setFillColor(sf::Color(144,193,211));
			if (board[i][j] == 4)
			field.setFillColor(sf::Color(29,124,194));
			if (board[i][j] == 5)
				field.setFillColor(sf::Color(223, 201, 202));

			

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

void addBlank(tgui::Gui &gui, std::wstring letter, int x, int y)
{
	tgui::Theme theme{ "../../ScrabbleCzeker/TGUI-0.8/themes/TransparentGrey.txt" };
	auto font = tgui::Font("../../ScrabbleCzeker/TGUI-0.8/fonts/Amble-Bold.ttf");
	auto blank = tgui::Button::create();
	blank->setRenderer(theme.getRenderer("Button"));
	blank->setPosition((1 + y) * 5 + y * 60 + 3, (1 + x) * 5 + x * 60 + 3);
	blank->setText(letter);
	blank->setTextSize(38);
	blank->setSize(54, 54);
	blank->setEnabled(0);
	blank->setInheritedFont(font);
	gui.add(blank);
}

int main()
{
	srand(time(NULL));
	sf::RenderWindow window(sf::VideoMode(980, 980), "Scrable Czeker", sf::Style::Close);

	tgui::Gui gui( window );

	std::vector<sf::RectangleShape> toBuild = buildBoard(window);

	addBlank(gui, L"K", 0, 0);
	addBlank(gui, L"O", 0, 1);
	addBlank(gui, L"L", 0, 2);
	addBlank(gui, L"�", 0, 3);
	addBlank(gui, L"D", 0, 4);
	addBlank(gui, L"A", 0, 5);

	while (window.isOpen())
	{
		sf::Event event;
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
				window.close();

			gui.handleEvent(event);
		}
		window.clear();
		for (int i = 0; i < toBuild.size(); i++)
		{
			window.draw(toBuild[i]);
		}
		gui.draw();
		window.display();
	}

	return 0;
}
