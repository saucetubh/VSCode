#include<stdio.h>
#include<stdlib.h>

/*
//What is the output?
void test (char *str)
{
    printf ("%c", *str ) ;
    if (* str == 'C')
        return ;
    if (*str >= 'A' && *str <= 'Z')
        test(str + 2) ;
    else
        test(++str ) ;
    printf ("%c" , *str ) ;
}
int main ()
{
    char str [] = "ProgRamInC";
    test(str) ;
    return 0;
}
*/

/*
//What is the output?
int main(void)
{
    int a[] = {5,1,15,20,25};
    int b[]={1,2,3,4,5,6,7,8};
    int i,j,m;
    i = ++a[1];
    j = a[1]++;
    m = a[i++];
    printf("%d %d %d\n", i, j, m);
    for(i = 1; i < 6; i++)
    {
        b[b[i]] = b[i];
        for(i = 0; i < 5; i++)
        {
            printf("%d", b[i]);
        }
    }
    return 0;
}
*/

/*
//What is the output?
int main()
{
    for (int i = 65; i <= 122; i++)
    {
        if (i == 97)
            printf(" ");
        else
        {
            if (i > 77 && i < 110)
                continue;
            printf("%c",i);
        }
    }
    return 0;
}

*/

/*
//What is the output?
int main()
{
	char *p;
	p = "Arnab";
	printf("%c\n", *&*p);
	return 0;
}
*/

//-----------------------------------------------------------

/*
//What is the output?
//What is the program doing?
int main()
{
    char str1[50] = "Arnab";
    char str2[50];
    char *stptr = str1;
    char *ptr2 = str2;
    int i=-1;
 	
    while(*stptr != '\0')
    {
     	stptr++;
     	i++;
    }
    while(i>=0)
    {
     	stptr--;
     	*ptr2 = *stptr;
     	ptr2++;
     	--i;
    }
    *ptr2='\0';
    printf("%c\n",str2[2]);
    printf("%s\n",str2);
    return 0;
}
*/
//-----------------------------------------------------------

/*
//What is the output?
int main()
{
	char *ptr;
	char string[] = "CP is the best course";
	ptr = string;
	ptr += 6;
	printf("%s\n",ptr);
	return 0;
}
*/
//-----------------------------------------------------------

/*
//What is the output?
int main()
{
	printf("%d\n", (int)sizeof(void *));
	return 0;
}
*/


#include<stdio.h>
int main()
{
	int a = 5;
	const int *ptr;
	ptr = &a;
	//*ptr = 10;
    a = 10;
    printf("%p\n", &a);
	return 0;
}


/*
//Fill in the blank so that the program prints the
//elements of the array marks?
int main()
{
    int i,*p;
    int marks[] = {55, 65, 75, 56, 78, 78, 90};
    for (i=0, p=&marks[0] ; i < 7 ; ________)
    {
        printf ("%d ", *p);
    }
    return 0;
}
*/


