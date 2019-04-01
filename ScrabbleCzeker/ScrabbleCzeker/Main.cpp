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
	sf::RectangleShape background(sf::Vector2f(1280, 1280));
	background.setFillColor(sf::Color::White);
	window.draw(background);
}

int main()
{
	sf::RenderWindow window(sf::VideoMode(1280, 1280), "Scrable Czeker");
	sf::CircleShape shape(100.f);
	shape.setFillColor(sf::Color::Green);

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
		window.draw(shape);
		gui.draw();
		window.display();
	}

	return 0;
}
