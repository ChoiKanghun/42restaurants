
#include "../includes/parsing.h"

t_dolls		dolls_value(char *str, int j)
{
	t_dolls dls;

	if (is_env(str, j))
		dls.value = get_env_value_2(str, j);
	else
		dls.value = NULL;
	dls.startline = get_startline(str, j);
	dls.endline = get_endline(str, j);
	dls.len = ft_strlen_null(dls.value) + \
	ft_strlen_null(dls.startline) + ft_strlen_null(dls.endline);
	return (dls);
}

char		*r_dollar(char *str, int j)
{
	t_dolls dls;
	char	*res;
	int		i;

	dls = dolls_value(str, j);
	if (!(res = malloc(dls.len + 1)))
		ft_error('\0', "Malloc", NULL, 1);
	i = 0;
	while (dls.startline && dls.startline[i])
	{
		res[i] = dls.startline[i];
		i++;
	}
	j = 0;
	while (dls.value && dls.value[j])
		res[i++] = dls.value[j++];
	j = 0;
	while (dls.endline && dls.endline[j])
		res[i++] = dls.endline[j++];
	res[i] = '\0';
	free_str(&str);
	free_str(&dls.value);
	free_str(&dls.startline);
	free_str(&dls.endline);
	return (res);
}

char		*get_dollar_str(char *str)
{
	int	j;

	j = 0;
	while (str[j])
	{
		if (!except_case(str, j))
		{
			str = r_dollar(str, j);
			j = -1;
		}
		j++;
	}
	return (str);
}

char		**get_dollar_tab(char **tab)
{
	int		i;

	i = 0;
	while (tab[i])
	{
		tab[i] = get_dollar_str(tab[i]);
		i++;
	}
	return (tab);
}

void		get_dollar(void)
{
	if (g_lst->cmd)
	{
		g_lst->cmd = get_dollar_str(g_lst->cmd);
		g_lst->arg = get_dollar_tab(g_lst->arg);
		g_lst->raw = get_dollar_tab(g_lst->raw);
	}
	if (g_lst->rdc_filetab)
		g_lst->rdc_filetab = get_dollar_tab(g_lst->rdc_filetab);
	if (g_lst->rdo_filetab)
		g_lst->rdo_filetab = get_dollar_tab(g_lst->rdo_filetab);
}
