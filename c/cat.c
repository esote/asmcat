#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

#define STDIN	0
#define STDOUT	1

int	cat(int, int);

int
main(int argc, char *argv[])
{
	int in = STDIN;
	int ret = 0;

	(void)argc;
	(void)*argv++;

	do {
		if (*argv) {
			if (*argv[0] == '-' && *argv[1] == '\0') {
				in = STDIN;
			} else if ((in = open(*argv, O_RDONLY)) == -1) {
				ret = 1;
			}

			(void)*argv++;
		}

		if (cat(in, STDOUT) == -1) {
			ret = 1;
		}

		if (in != STDIN && close(in) == -1) {
			ret = 1;
		}

	} while (*argv);

	return ret;
}

int
cat(int in, int out)
{
	ssize_t r, offset, w = 0;
	static char buffer[BUFSIZ];

	while ((r = read(in, buffer, BUFSIZ)) != -1 && r != 0) {
		for (offset = 0; r; r -= w, offset += w) {
			if ((w = write(out, buffer + offset, (size_t)r)) == 0
				|| w == -1) {
				return -1;
			}
		}
	}

	if (r < 0) {
		return -1;
	}

	return 0;
}
