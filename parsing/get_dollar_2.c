
#include "../includes/parsing.h"

char	*get_startline(char *str, int j)
{
	char	*start;
	int		y;

	if (!j)
		return (NULL);
	if (!(start = malloc(j)))
		ft_error('\0', "Malloc", NULL, 1);
	y = 0;
	while (y < j)
	{
		start[y] = str[y];
		y++;
	}
	start[y] = '\0';
	return (start);
}

char	*get_endline(char *str, int j)
{
	char	*end;
	int		len;
	int		k;

	len = 0;
	j++;
	if (!str[j + 1])
		return (NULL);
	while (!is_end_var_name(str, j))
		j++;
	if (bracket_case(str, j))
		j++;
	k = j;
	while (str[j++])
		len++;
	if (!(end = malloc(len + 1)))
		ft_error('\0', "Malloc", NULL, 1);
	len = 0;
	while (str[k])
		end[len++] = str[k++];
	end[len] = '\0';
	return (end);
}

char	*get_env_name_2check(char *str, int j)
{
	int		len;
	int		i;
	char	*tmp;

	j++;
	if (str[j] == '{')
		j++;
	len = j;
	i = 0;
	while (str[j] && !is_end_var_name(str, j))
		j++;
	if (!(tmp = malloc(j - len + 1)))
		ft_error('\0', "Malloc", NULL, 1);
	while (len < j && !is_end_var_name(str, len))
		tmp[i++] = str[len++];
	tmp[i] = '\0';
	return (tmp);
}

t_value	new_value(char *str, int j)
{
	t_value	v;
	int		len;
	int		i;

	v.name = get_env_name_2check(str, j);
	i = 0;
	while (g_global_env[i] && !ft_envcmp(g_global_env[i], v.name))
		i++;
	j = 0;
	while (g_global_env[i][j] != '=')
		j++;
	len = 0;
	v.i = i;
	v.j = j + 1;
	while (g_global_env[i][++j])
		len++;
	if (!(v.value = malloc(len + 1)))
		ft_error('\0', "Malloc", NULL, 1);
	free_str(&v.name);
	return (v);
}

char	*get_env_value_2(char *str, int j)
{
	t_value v;

	v = new_value(str, j);
	v.y = 0;
	while (g_global_env[v.i][v.j])
		v.value[v.y++] = g_global_env[v.i][v.j++];
	v.value[v.y] = '\0';
	return (v.value);
}
