#include "Main.h"
#include <SFML/Graphics.hpp>
#include <TGUI/TGUI.hpp>
#include <vector>

void buildBoard(sf::RenderWindow &window)
{
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
	background.setFillColor(sf::Color::White);
	window.draw(background);
	for (int i = 0; i < board.size(); i++)
	{
		for (int j = 0; j < board[i].size(); j++)
		{
			sf::RectangleShape field(sf::Vector2f(60, 60));
			field.setPosition((1 + j) * 5 + j * 60, (1 + i) * 5 + i * 60);
			if (board[i][j] == 0)
			field.setFillColor(sf::Color::Green);
			if (board[i][j] == 1)
			field.setFillColor(sf::Color::Yellow);
			if (board[i][j] == 2)
			field.setFillColor(sf::Color::Red);
			if (board[i][j] == 3)
			field.setFillColor(sf::Color::Cyan);
			if (board[i][j] == 4)
			field.setFillColor(sf::Color::Blue);
			if (board[i][j] == 5)
			field.setFillColor(sf::Color::Magenta);
			window.draw(field);
		}
	}
}

void addBlank(tgui::Gui &gui, std::string letter, int x, int y)
{
	tgui::Theme theme{ "C:/Users/HP/Desktop/projekt_z/ScrabbleChecker/ScrabbleCzeker/TGUI-0.8/themes/TransparentGrey.txt" };
	auto blank = tgui::Button::create();
	blank->setRenderer(theme.getRenderer("Button"));
	blank->setPosition((1 + y) * 5 + y * 60 + 3, (1 + x) * 5 + x * 60 + 3);
	blank->setText(letter);
	blank->setTextSize(38);
	blank->setSize(54, 54);
	blank->setEnabled(0);
	gui.add(blank);
}

int main()
{
	sf::RenderWindow window(sf::VideoMode(980, 980), "Scrable Czeker");

	tgui::Gui gui( window );

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
		buildBoard(window);
		addBlank(gui, "K", 0, 0);
		addBlank(gui, "O", 0, 1);
		addBlank(gui, "T", 0, 2);
		gui.draw();
		window.display();
	}

	return 0;
}
