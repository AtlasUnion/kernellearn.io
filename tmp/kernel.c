const int color = 0x07;
char* current_pos = (char*) 0xB8000;
char* current_line = (char*) 0xB8000;

void print_String(const char* string) {
    char* video = current_pos;
    while( *string != 0 ) {
        if (*string == '\n') {
            current_line += 0xA0;
            video = current_line;
            string++;
            continue;
        }
        *video++ = *string++;
        *video++ = color;
        if (video > (current_line + 0x9F)) {
            current_line += 0xA0;
        }
    }
    current_pos = video; 
}

void print_in_hex(unsigned long long int input_Num) {
    char* video = current_pos;
    int i;
    for (i = 7; i >= 0; i--) {
        unsigned int tmp = input_Num;
        char hex;
        if ((hex = ( ( tmp >> (i*4) ) & (0xF) )) <= 9) {
            hex += 48;
        } else {
            hex += 55;
        }
        *video++ = hex;
        *video++ = color;
    }
    current_pos = video;
}

void clear_Screen() {
    char* video = current_pos;
    int i;
    char c = 32;
    for (i = 0; i < 80*25; i++) {
        *video++ = c;
        *video++ = color;
    }
}

int kernel_main(void) {
    clear_Screen();
    char* Welcome = "Welcome to my OS";
    print_String(Welcome);
    asm("mov $0xFFFFFFFF, %eax");
    char* a = current_pos;
    asm("hlt");
    return 0;
}