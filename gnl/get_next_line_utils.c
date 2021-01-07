
#include "get_next_line.h"

int		ft_len(char *str)
{
	int cmp;

	if (!str)
		return (0);
	cmp = 0;
	while (str[cmp])
		cmp++;
	return (cmp);
}

char	*ft_dup(const char *str, int len, char *str_free)
{
	char	*new_str;
	int		cmp;

	if (!str)
	{
		if (!(new_str = (char *)malloc(sizeof(char) * 1)))
			ft_error('\0', "Malloc", NULL, 1);
		new_str[0] = '\0';
	}
	else
	{
		if (!(new_str = (char *)malloc(sizeof(char) * (len + 1))))
			ft_error('\0', "Malloc", NULL, 1);
		if (new_str == NULL)
			return (NULL);
		cmp = 0;
		while (cmp < len)
		{
			new_str[cmp] = str[cmp];
			cmp++;
		}
		new_str[cmp] = '\0';
	}
	free_str(&str_free);
	return (new_str);
}

int		ft_search(char *str)
{
	int cmp;

	cmp = 0;
	if (!str)
		return (-1);
	while (str[cmp])
	{
		if (str[cmp] == '\n')
			return (cmp);
		cmp++;
	}
	return (-1);
}

char	*ft_settle(char *str, int pass)
{
	(void)pass;
	free(str);
	str = NULL;
	return (str);
}
