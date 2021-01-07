/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line_utils.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kchoi <kchoi@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/05/19 20:07:23 by kchoi             #+#    #+#             */
/*   Updated: 2020/05/19 20:07:25 by kchoi            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"

int		ft_strlen(char *str)
{
	int	i;

	i = 0;
	if (!str)
		return (0);
	while (str[i])
		i++;
	return (i);
}

char	*ft_strjoin_custom(char *save, char *buff)
{
	int		i;
	int		save_len;
	int		buff_len;
	char	*dest;
	int		j;

	i = 0;
	save_len = ft_strlen(save);
	buff_len = ft_strlen(buff);
	if (!(dest = (char *)malloc(save_len + buff_len + 1)))
		return (NULL);
	while (i < save_len)
	{
		dest[i] = save[i];
		i++;
	}
	j = 0;
	while (j < buff_len)
	{
		dest[i + j] = buff[j];
		j++;
	}
	dest[i + j] = '\0';
	free(save);
	return (dest);
}

int		if_newline_in_str(char *save)
{
	int	i;

	if (!save)
		return (0);
	i = 0;
	while (save[i])
	{
		if (save[i] == '\n')
			return (1);
		i++;
	}
	return (0);
}
