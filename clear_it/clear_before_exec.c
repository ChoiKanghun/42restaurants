
#include "../includes/parsing.h"

char	*g_map;

int		is_spe_carac(char *str, int i)
{
	if (g_map[i] == '2')
	{
		if (str[i] == 36)
			return (0);
		if (str[i] == 33 || (str[i] >= 35 && str[i] <= 47))
			return (1);
		if (str[i] >= 58 && str[i] <= 64)
			return (1);
		if (str[i] == 91 || (str[i] >= 93 && str[i] < 96))
			return (1);
		if (str[i] >= 123 && str[i] <= 126)
			return (1);
		if (str[i] >= 65 && str[i] <= 90)
			return (1);
		if (str[i] >= 97 && str[i] <= 122)
			return (1);
	}
	return (0);
}

int		to_print(char *str, int i)
{
	if (g_map[i] == '1')
		return (1);
	if (str[i] == '\\' && !is_esc(str, i) && !is_spe_carac(str, i + 1))
		return (0);
	if (g_map[i] == '3' || g_map[i] == '4')
		return (0);
	return (1);
}

int		to_keep_len(char *str)
{
	int	nb;
	int	i;

	nb = 0;
	i = 0;
	while (str[i])
	{
		if (to_print(str, i))
			nb++;
		i++;
	}
	return (nb);
}

char	*clear_it(char *str)
{
	char	*res;
	int		len;
	int		j;
	int		k;

	g_map = map_quote(str);
	len = to_keep_len(str);
	if (!(res = malloc(len + 1)))
		ft_error('\0', "Malloc", NULL, 1);
	j = 0;
	k = 0;
	while (str[j])
	{
		if (to_print(str, j))
			res[k++] = str[j];
		j++;
	}
	res[k] = '\0';
	free_str(&g_map);
	free_str(&str);
	return (res);
}

void	clear_before_exec(void)
{
	if (g_lst->cmd)
		clear_str(&g_lst->cmd);
	if (g_lst->arg)
		clear_tab(&g_lst->arg);
	if (g_lst->raw)
		clear_tab(&g_lst->raw);
	if (g_lst->rdc_filetab)
	{
		clear_tab(&g_lst->rdc_filetab);
		g_lst->rdc_filename = get_last(g_lst->rdc_filetab);
	}
	if (g_lst->rdo_filetab)
	{
		clear_tab(&g_lst->rdo_filetab);
		g_lst->rdo_filename = get_last(g_lst->rdo_filetab);
	}
}
