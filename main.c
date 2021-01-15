# include "libasm.h"

void check_strlen()
{
	char *empty = "";
	char *hello_world = "Hello world !";
	char *alphabet = "42seoul abcdefghijklmnopqrstuvwxyz";

	printf("\n================================\n");
	printf("========== FT_STRLEN ===========\n");
	printf("================================\n\n");
	printf("%-40s: \"%s\"\n", "char *", empty);
	printf("%-40s: 0\n", "expected length");
	printf("%-40s: %zu\n", "libc", strlen(empty));	
	printf("%-40s: %zu\n", "libasm", ft_strlen(empty));
	printf("\n");
	printf("%-40s: \"%s\"\n", "char *", hello_world);
	printf("%-40s: 0\n", "expected length");
	printf("%-40s: %zu\n", "libc", strlen(hello_world));	
	printf("%-40s: %zu\n", "libasm", ft_strlen(hello_world));
	printf("\n");
	printf("%-40s: \"%s\"\n", "char *", alphabet);
	printf("%-40s: 0\n", "expected length");
	printf("%-40s: %zu\n", "libc", strlen(alphabet));	
	printf("%-40s: %zu\n", "libasm", ft_strlen(alphabet));
	printf("\n");
}

void clear_buffer(char *buffer, int size)
{
	int i = 0;
	while (i < size)
		buffer[i++] = 0;
}

void check_strcpy()
{
	char buffer[30];
	
	char *empty = "";
	char *hello_world = "Hello world !";
	char *alphabet = "abcdefghijklmnopqrstuvwxyz";
	
	printf("\n================================\n");
	printf("========== FT_STRCPY ===========\n");
	printf("================================\n\n");
	printf("%-40s: \"%s\"\n", "char []", empty);
	printf("%-40s: buffer[50]\n", "copy to");
	printf("%-40s: \"%s\"\n", "libc", strcpy(buffer, empty));	
	clear_buffer(buffer, 30);
	printf("%-40s: \"%s\"\n", "libasm", ft_strcpy(buffer, empty));	
	clear_buffer(buffer, 30);
	printf("\n");
	printf("%-40s: \"%s\"\n", "char []", hello_world);
	printf("%-40s: buffer[50]\n", "copy to");
	printf("%-40s: \"%s\"\n", "libc", strcpy(buffer, hello_world));	
	clear_buffer(buffer, 30);
	printf("%-40s: \"%s\"\n", "libasm", ft_strcpy(buffer, hello_world));	
	clear_buffer(buffer, 30);
	printf("\n");
	printf("%-40s: \"%s\"\n", "char []", alphabet);
	printf("%-40s: buffer[50]\n", "copy to");
	printf("%-40s: \"%s\"\n", "libc", strcpy(buffer, alphabet));	
	clear_buffer(buffer, 30);
	printf("%-40s: \"%s\"\n", "libasm", ft_strcpy(buffer, alphabet));
	clear_buffer(buffer, 30);
	printf("\n");
	printf("%-40s: \%s\"\n", "char []", alphabet);
	printf("%-40s: buffer[50]\n", "copy to");
	printf("%-40s: \"%p\"\n", "libc", strcpy(buffer, alphabet));
	printf("%-40s: \"%p\"\n", "libasm", strcpy(buffer, alphabet));
}

void check_strcmp()
{
	char *empty = "";
	char *hello_world = "Hello world !";
	char *hello_human = "Hello human !";
	char *hello_world2 = "Hello world !";
	
	printf("\n================================\n");
	printf("========== FT_STRCMP ===========\n");
	printf("================================\n\n");
	printf("%-40s: \"%s\"\n", "char *", hello_world);
	printf("%-40s: \"%s\"\n", "compared to", hello_human);
	printf("%-40s: \"%d\"\n", "cmp result: libc", strcmp(hello_world, hello_human));
	printf("%-40s: \"%d\"\n", "cmp result: libasm", ft_strcmp(hello_world, hello_human));
	printf("\n");
	printf("%-40s: \"%s\"\n", "char *", hello_world);
	printf("%-40s: \"%s\"\n", "compared to", hello_world2);
	printf("%-40s: \"%d\"\n", "cmp result: libc", strcmp(hello_world, hello_world2));
	printf("%-40s: \"%d\"\n", "cmp result: libasm", ft_strcmp(hello_world, hello_world2));
	printf("\n");
	printf("%-40s: \"%s\"\n", "char *", hello_world2);
	printf("%-40s: \"%s\"\n", "compared to", empty);
	printf("%-40s: \"%d\"\n", "cmp result: libc", strcmp(hello_world2, empty));
	printf("%-40s: \"%d\"\n", "cmp result: libasm", ft_strcmp(hello_world2, empty));
	printf("\n");
}
void check_write()
{
	char *hello_world = "Coucou";
	char *empty = "";

	printf("\n================================\n");
	printf("========== FT_WRITE ============\n");
	printf("================================\n\n");
	printf("%-40s: \"%s\"\n", "char *", hello_world);
	printf("%-40s: \"%zu\"\n", "write 7 ret value libc", write(1, hello_world, 7));
	printf("%-40s: \"%zu\"\n", "write 7 ret value libasm", ft_write(1, hello_world, 7));
	printf("\n");
	printf("%-40s: \"%s\"\n", "char *", empty);
	printf("%-40s: \"%zu\"\n", "write empty str libc", write(1, empty, 0));
	printf("%-40s: \"%zu\"\n", "write empty str libasm", ft_write(1, empty, 0));
	printf("\n");
	printf("%-40s: \"%s\"\n", "char *", "NULL");
	printf("%-40s: \"%zu\"\n", "write null libc", write(-7, NULL, 7));
	printf("%-40s: \"%zu\"\n", "write null libasm", ft_write(-7, NULL, 7));
	printf("%-40s: \"%s\"\n", "char *", "-1, \"not null\", 7");
	printf("%-40s: \"%zu\"\n", "write null libc", write(-1, "not null", 7));
	printf("%-40s: \"%zu\"\n", "write null libasm", ft_write(-1, "not null", 7));
	printf("%-40s: \"%s\"\n", "char *", "1, NULL, 7");
	printf("%-40s: \"%zu\"\n", "write null libc", write(1, NULL, 7));
	printf("%-40s: \"%zu\"\n", "write null libasm", ft_write(1, NULL, 7));
}

void check_read()
{
	int fd = open("main.c", O_RDONLY);
	char buff1[500];
	int ret = 1;
	printf("\n================================\n");
	printf("========== FT_READ =============\n");
	printf("================================\n\n");
	printf("%-40s: \n", "header main.c | libc ");
	ret = read(fd, buff1, 500);
	buff1[ret] = 0;
	printf("[return : %d]\n|%s|\n", ret, buff1);
	printf("\n");
	close(fd);
	fd = open("main.c", O_RDONLY);
	clear_buffer(buff1, 500);
	printf("%-40s: \n", "header main.c | libasm ");
	ret = ft_read(fd, buff1, 500);
	buff1[ret] = 0;
	printf("[return : %d]\n|%s|\n", ret, buff1);
	printf("\n");
	clear_buffer(buff1, 500);
	close(fd);

	fd = open("test", O_RDONLY);
	printf("%-40s: \n", "file test | libc ");
	ret = read(fd, buff1, 500);
	buff1[ret] = 0;
	printf("[return : %d]\n|%s|\n", ret, buff1);
	printf("\n");
	close(fd);
	fd = open("test", O_RDONLY);
	clear_buffer(buff1, 500);
	printf("%-40s: \n", "file test | libasm ");
	ret = ft_read(fd, buff1, 500);
	buff1[ret] = 0;
	printf("[return : %d]\n|%s|\n", ret, buff1);
	printf("\n");
	clear_buffer(buff1, 500);
	close(fd);
}

void check_strdup()
{
	char *hello_world = "Hello world !";
	char *empty = "";
	char *save;
	char *save2;
	
	printf("\n================================\n");
	printf("========== FT_STRDUP ===========\n");
	printf("================================\n\n");
	printf("%-40s: \"%s\"\n", "char *", hello_world);
	save = strdup(hello_world);
	printf("%-40s: \"%s\"\n", "libc", save);
	free(save);
	save = NULL;
	save2 = ft_strdup(hello_world);
	printf("%-40s: \"%s\"\n", "libasm", save2);
	free(save2);
	save2 = NULL;
	printf("\n");

	printf("%-40s: \"%s\"\n", "char *", empty);
	save = strdup(empty);
	printf("%-40s: \"%s\"\n", "libc", save);
	free(save);
	save = NULL;
	save2 = ft_strdup(empty);
	printf("%-40s: \"%s\"\n", "libasm", save2);
	free(save2);
	save2 = NULL;
	printf("\n");

}

int main()
{
	check_strlen();
	check_strcpy();
	check_strcmp();
	check_write();
	check_read();
	check_strdup();
}
