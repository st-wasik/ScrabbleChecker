#pragma once
#include <SFML/Graphics.hpp>
#include <TGUI/TGUI.hpp>
#include <array>
#include <mutex>
#include <atomic>
class Application
{
public:
	Application();
	~Application();
	void run();
	void read_stream();
private:
	sf::RenderWindow window;

	struct letter
	{
		std::shared_ptr<tgui::Button> tile;
		char status = 'B';
	};

	sf::Texture t, star;
	std::vector<sf::RectangleShape> shapes;
	std::array<std::array<letter, 15>, 15> tiles;

	tgui::Gui board;
	tgui::Theme theme;

	tgui::Font font;

	void addTile(int letter, int x, int y, char status);

	std::vector<sf::RectangleShape> buildBoard();

	void read_words();

	void clear();

	std::shared_ptr<tgui::ListBox> createList();

	std::shared_ptr<tgui::ListBox> wordList;

	int convertCharacter(int value);

	std::mutex mutex;

	std::atomic_bool close;
};

