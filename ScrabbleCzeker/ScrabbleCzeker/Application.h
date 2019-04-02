#pragma once
#include <SFML/Graphics.hpp>
#include <TGUI/TGUI.hpp>
class Application
{
public:
	Application();
	~Application();
	void run();
private:
	sf::RenderWindow window;

	sf::Texture t, star;
	std::vector<sf::RectangleShape> shapes;

	tgui::Gui board;
	tgui::Theme theme;

	tgui::Font font;

	void addTile(std::wstring letter, int x, int y);

	std::vector<sf::RectangleShape> buildBoard();
};

