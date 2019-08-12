#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdint.h>

struct printf_flags
{
	bool left_justify;
	bool force_plus_minus_sign;
	bool space_before_positive;
	bool hex_control;
	bool padding_with_zero;
};

struct printf_width
{
	uint64_t min_number_char_to_print;
	// TODO: something else here
};

struct printf_precision
{
	uint64_t min_number_digit_to_print;
	// TODO: something else here
};

struct printf_length
{
	bool is_long;
	bool is_long_long;
};

struct printf_control
{
	struct printf_flags flags;
	struct printf_width width;
	struct printf_precision precision;
};

static bool print(const char *data, size_t length)
{
	const unsigned char *bytes = (const unsigned char *)data;

	for (size_t i = 0; i < length; i++)
	{
		if (putchar(bytes[i]) == EOF)
			return false;
	}

	return true;
}

static int printf_unsigned_helper(unsigned long long int input_num)
{
	if (input_num == 0)
		return 0;
	char digit_to_be_print = (input_num % 10) + 48;
	if (printf_unsigned_helper(input_num / 10) == -1)
		return -1;
	if (!print(&digit_to_be_print, sizeof(digit_to_be_print)))
		return -1;
	return 0;
}

static int printf_hex_helper(unsigned long long int input_num)
{
	if (input_num == 0)
		return 0;
	int remainder = input_num % 16;
	char hex_to_be_print;
	if (remainder < 10)
	{
		hex_to_be_print = remainder + 48;
	}
	else
	{
		hex_to_be_print = remainder + 55;
	}
	if (printf_hex_helper(input_num / 16) == -1)
		return -1;
	if (!print(&hex_to_be_print, sizeof(hex_to_be_print)))
		return -1;
	return 0;
}

static void printf_control_parser(char **format)
{
}

// TODO: support %d
// TODO: support minimum print char
int printf(const char *restrict format, ...)
{
	va_list parameters;
	va_start(parameters, format);

	int written = 0;

	while (*format != '\0')
	{
		size_t maxrem = INT_MAX - written;

		// Case: no special format
		if (format[0] != '%' || format[1] == '%')
		{
			if (format[0] == '%')
				format++;
			size_t amount = 1;
			// not zero and not format char
			while (format[amount] && format[amount] != '%')
				amount++;
			if (maxrem < amount)
			{
				return -1;
			}
			if (!print(format, amount))
				return -1;
			format += amount;
			written += amount;
			continue;
		}

		// Case: format[0] = '%' and format[1] != '%'
		// Special format
		const char *format_begun_at = format++;
		bool is_long = false;
		bool is_long_long = false;

		if (*format == 'l')
		{
			format++;

			if (*format == 'l')
			{
				format++;
				is_long_long = true;
			}
			else
			{
				is_long = true;
			}
		}

		if (*format == 'c')
		{
			format++;
			char c = (char)va_arg(parameters, int);
			if (!maxrem)
			{
				return -1;
			}
			if (!print(&c, sizeof(c)))
				return -1;
			written++;
		}
		else if (*format == 's')
		{
			format++;
			const char *str = va_arg(parameters, const char *);
			size_t len = strlen(str);
			if (maxrem < len)
			{
				return -1;
			}
			if (!print(str, len))
				return -1;
			written += len;
		}
		else if (*format == 'u')
		{
			format++;

			unsigned long long int i;
			if (is_long)
			{
				is_long = false;
				i = va_arg(parameters, unsigned long int);
			}
			else if (is_long_long)
			{
				is_long_long = false;
				i = va_arg(parameters, unsigned long long int);
			}
			else
			{
				i = va_arg(parameters, unsigned int);
			}

			if (i == 0)
			{
				char digit_to_be_print = '0';
				if (!print(&digit_to_be_print, sizeof(digit_to_be_print)))
					return -1;
			}
			else
			{
				if (printf_unsigned_helper(i) == -1) // recursively printing
					return -1;
			}
		}
		else if (*format == 'X') // print in hex; Always print as unsigned
		{
			format++;
			unsigned long long int i;
			if (is_long)
			{
				is_long = false;
				i = va_arg(parameters, unsigned long int);
			}
			else if (is_long_long)
			{
				is_long_long = false;
				i = va_arg(parameters, unsigned long long int);
			}
			else
			{
				i = va_arg(parameters, unsigned int);
			}

			if (i == 0)
			{
				char hex_to_be_print = '0';
				if (!print(&hex_to_be_print, sizeof(hex_to_be_print)))
					return -1;
			}
			else
			{
				if (printf_hex_helper(i) == -1) // recursively printing
					return -1;
			}
		}
		else
		{
			format = format_begun_at;
			size_t len = strlen(format);
			if (maxrem < len)
			{
				return -1;
			}
			if (!print(format, len))
				return -1;
			written += len;
			format += len;
		}
	}

	va_end(parameters);
	return written;
}