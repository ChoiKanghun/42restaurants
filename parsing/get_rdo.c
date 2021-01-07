
#include "../includes/parsing.h"

char	*g_map;

int		find_rdo(char *str)
{
	int	i;

	i = 0;
	while (str[i])
	{
		if (str[i] == '<' && !is_esc(str, i) && g_map[i] == '0')
			return (1);
		i++;
	}
	return (0);
}

int		count_rdo(char *str)
{
	int	i;
	int	nb;

	i = 0;
	nb = 0;
	while (str[i])
	{
		if (g_map[i] == '0' && !is_esc(str, i))
		{
			if (str[i] == '<')
				nb++;
		}
		i++;
	}
	return (nb);
}

int		is_rdo(char *str, int i)
{
	if (!is_esc(str, i) && g_map[i] == '0')
	{
		if (str[i] == '<')
			return (1);
	}
	return (0);
}

char	*get_rdo_name(char *str, int i)
{
	char	*name;
	int		nb;
	int		y;

	y = 0;
	nb = 0;
	name = NULL;
	while (nb != i && str[y])
	{
		if (is_rdo(str, y))
			nb++;
		y++;
	}
	if (nb == i)
		name = get_name(str, y, 0);
	return (name);
}

char	**get_rdo_filetab(char *str)
{
	char	**tab;
	int		nb;
	int		i;

	g_map = map_quote(str);
	if (find_rdo(str))
	{
		nb = count_rdo(str);
		if (!(tab = malloc(sizeof(char*) * nb + 1)))
			ft_error('\0', "Malloc", NULL, 1);
		i = 1;
		while (i <= nb)
		{
			tab[i - 1] = get_rdo_name(str, i);
			i++;
		}
		tab[i - 1] = NULL;
		return (tab);
	}
	return (NULL);
}
