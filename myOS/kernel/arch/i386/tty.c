#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include <kernel/tty.h>

#include "vga.h"

// TODO: rewrite size to be more general: uint32 to unsigned long

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
static uint16_t *const VGA_MEMORY = (uint16_t *)0xC00B8000;

static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t *terminal_buffer;

/**
 * Init terminal to blank screen; Set cursor to top left of screen
 */
void terminal_initialize(void)
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	terminal_buffer = VGA_MEMORY;

	for (size_t y = 0; y < VGA_HEIGHT; y++)
	{
		for (size_t x = 0; x < VGA_WIDTH; x++)
		{
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}

void terminal_setcolor(uint8_t color)
{
	terminal_color = color;
}

/**
 * Put entry: char, color at (x,y) location
 */
void terminal_put_entry_at(unsigned char c, uint8_t color, size_t x, size_t y)
{
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

/**
 * Put char c at current cursor position and increment cursor
 * Cursor will wrap around edge 
 */
void terminal_put_char(char c)
{
	unsigned char uc = c;
	if (uc == '\n')
	{
		terminal_column = VGA_WIDTH - 1; // so below code will advance the terminal to next row
	}
	else
	{
		terminal_put_entry_at(uc, terminal_color, terminal_column, terminal_row);
	}

	terminal_column++;
	if (terminal_column == VGA_WIDTH)
	{
		terminal_column = 0;

		terminal_row++;
		if (terminal_row == VGA_HEIGHT)
		{
			terminal_row = 0;
		}
	}
}

void terminal_write(const char *data, size_t size)
{
	for (size_t i = 0; i < size; i++)
	{
		terminal_put_char(data[i]);
	}
}

void terminal_write_string(const char *data)
{
	terminal_write(data, strlen(data));
}