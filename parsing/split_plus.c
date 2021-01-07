/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   split_plus.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/01/07 20:19:46 by kchoi             #+#    #+#             */
/*   Updated: 2021/01/07 20:29:44 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/parsing.h"

char		*g_map;

static int	sep(char c, int i, char charset, char *str)
{
	if (c == charset && g_map[i] == '0' && !is_esc(str, i))
		return (1);
	return (0);
}

static int	set_sep(char *str, char charset)
{
	int	count;
	int	i;

	count = 0;
	i = 0;
	while (str[i])
	{
		if (sep(str[i], i, charset, str))
			count++;
		i++;
	}
	return (count + 1);
}

static char	*finder(char *str, int i, char charset)
{
	char	*part;
	int		j;
	int		len;

	while (str[i] == ' ')
		i++;
	len = 0;
	j = i;
	while (str[i] && !sep(str[i], i, charset, str))
	{
		len++;
		i++;
	}
	if (!(part = malloc(len + 1)))
		ft_error('\0', "Malloc", NULL, 1);
	i = j;
	j = 0;
	while (len)
	{
		part[j++] = str[i++];
		len--;
	}
	part[j] = '\0';
	return (part);
}

char		**split_plus(char *str, char charset)
{
	int		i;
	int		j;
	char	**tab;

	g_map = map_quote(str);
	i = set_sep(str, charset);
	if (!(tab = malloc((i + 1) * sizeof(char*))))
		ft_error('\0', "Malloc", NULL, 1);
	i = 0;
	j = 0;
	while (i < ft_strlen(str))
	{
		if (str[i] && !sep(str[i], i, charset, str))
		{
			tab[j++] = finder(str, i, charset);
			while (str[i] && !sep(str[i], i, charset, str))
				i++;
		}
		i++;
	}
	tab[j] = NULL;
	free_str(&g_map);
	return (tab);
}
