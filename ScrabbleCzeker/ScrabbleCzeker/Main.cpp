#include "Main.h"

#include <SFML/Graphics.hpp>
#include <TGUI/TGUI.hpp>

int main()
{
	sf::RenderWindow window(sf::VideoMode(200, 200), "SFML works!");
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
		window.draw(shape);
		gui.draw();
		window.display();
	}

	return 0;
}
