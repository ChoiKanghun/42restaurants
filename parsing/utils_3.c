/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils_3.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:21:53 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:21:55 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/parsing.h"

int	ft_envcmp(char *s1, char *s2)
{
	int	i;

	i = 0;
	while (s1[i] == s2[i])
		i++;
	if (s1[i] == '=' && !s2[i])
		return (1);
	return (0);
}

int	is_env(char *str, int j)
{
	char	*tmp;
	int		i;

	i = 0;
	tmp = get_env_name_2check(str, j);
	while (g_global_env[i])
	{
		if (ft_envcmp(g_global_env[i], tmp))
		{
			free_str(&tmp);
			return (1);
		}
		i++;
	}
	free_str(&tmp);
	return (0);
}

int	is_end_var_name(char *str, int i)
{
	if (str[i - 2] == '$' && (str[i - 1] >= '0' && str[i - 1] <= '9'))
		return (1);
	if (str[i] >= 32 && str[i] <= 47)
		return (1);
	if (str[i] >= 58 && str[i] <= 64)
		return (1);
	if (str[i] >= 91 && str[i] <= 96)
		return (1);
	if (str[i] >= 124 && str[i] <= 126)
		return (1);
	if (!str[i])
		return (1);
	return (0);
}

int	ft_strlen_null(const char *str)
{
	int count;

	count = 0;
	if (str)
	{
		while (str[count])
			count++;
		return (count);
	}
	return (0);
}

int	except_case(char *str, int i)
{
	char *map;

	map = map_quote(str);
	if (str[i] == '$')
	{
		if ((str[i + 1] >= 32 && str[i + 1] <= 47)
			|| (str[i + 1] >= 58 && str[i + 1] <= 62)
			|| (str[i + 1] == 64)
			|| (str[i + 1] >= 91 && str[i + 1] <= 96)
			|| (str[i + 1] >= 124 && str[i + 1] <= 126)
			|| (!str[i + 1])
			|| (map[i] == '1')
			|| (is_esc(str, i)))
		{
			free_str(&map);
			return (1);
		}
		free_str(&map);
		return (0);
	}
	free_str(&map);
	return (1);
}
