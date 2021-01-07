
#include "../includes/exec.h"

static int		ft_cmp_string(char const *s, char c)
{
	int	cmp_string;
	int	cmp_sep;

	cmp_string = 0;
	cmp_sep = 0;
	while (s[cmp_string])
	{
		if (((s[cmp_string] == c && cmp_string != 0) &&
		s[cmp_string - 1] != c) ||
		(s[cmp_string] != c && s[cmp_string + 1] == '\0'))
			cmp_sep++;
		cmp_string++;
	}
	return (cmp_sep);
}

static char		*ft_create_string(char const *s, int nb_car)
{
	int		cmp;
	char	*new_string;

	if (!(new_string = (char *)malloc(sizeof(char) * (nb_car + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	if (new_string == NULL)
		return (0);
	cmp = 0;
	while (cmp < nb_car)
	{
		new_string[cmp] = s[cmp];
		cmp++;
	}
	new_string[cmp] = '\0';
	return (new_string);
}

static char		**ft_sep_string(char const *s, char c, char **total_string)
{
	int		cmp_start;
	int		cmp_end;
	int		cmp_total;
	char	*new_string;

	cmp_total = 0;
	cmp_end = 0;
	while (s[cmp_end])
	{
		cmp_start = cmp_end;
		if (s[cmp_end] != c)
		{
			while (s[cmp_end] != c && s[cmp_end])
				cmp_end++;
			new_string = ft_create_string(&s[cmp_start], (cmp_end - cmp_start));
			total_string[cmp_total] = new_string;
			cmp_total++;
		}
		else
			cmp_end++;
	}
	return (total_string);
}

char			**ft_split(char const *s, char c)
{
	int		cmp_string;
	char	**total_string;

	if (!s)
		return (0);
	cmp_string = ft_cmp_string(s, c);
	if (!(total_string = (char **)malloc(sizeof(char*) * (cmp_string + 1))))
		ft_error('\0', "Malloc", NULL, 1);
	total_string = ft_sep_string(s, c, total_string);
	total_string[cmp_string] = NULL;
	return (total_string);
}
