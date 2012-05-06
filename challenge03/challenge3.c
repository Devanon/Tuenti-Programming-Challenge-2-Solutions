#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int buy_point;
    int sell_point;
    int gain;
} node;

node recursive_search(int* array, int left_limit, int right_limit){
    node return_data;

    // Array length < 2
    if (right_limit - left_limit < 2) {
        return_data.buy_point = left_limit;
        return_data.sell_point = right_limit;
        return_data.gain = *(array + right_limit) - *(array + left_limit);

        return return_data;

    // Split array by half and find max/min
    } else {
        int mid = left_limit + (right_limit - left_limit) / 2;
        int min = mid;
        int max = mid + 1;

        // Recursive calls
        node left_half_node = recursive_search(array, left_limit, mid);
        node right_half_node = recursive_search(array, mid + 1, right_limit);

        // Min in left part
        int i = mid;
        while (i >= left_limit){
            if (*(array + i) < *(array + min))
                min = i;
            i--;
        }
        // Max in right part
        i = mid + 1;
        while (i <= right_limit){
            if (*(array + i) > *(array + max))
                max = i;
            i++;
        }

        // Calculate the max gain
        int gain = *(array + max) - *(array + min);
        return_data.gain = gain;
        return_data.buy_point = min;
        return_data.sell_point = max;

        // Return max gain
        if (left_half_node.gain > right_half_node.gain){
            if (left_half_node.gain > gain) {
                return left_half_node;
            } else {
                return return_data;
            }

        } else {
            if (right_half_node.gain > gain) {
                return right_half_node;
            } else {
                return return_data;
            }
        }
    }


}

int main(int argc, char* argv)
{
    unsigned long int array_space_reserved = 1024;
    int *array_data = (int*) malloc(sizeof(int) * array_space_reserved);
    unsigned long int array_space_used = 0;

    while (!feof(stdin)){

        // Increase array size if needed
        if (array_space_used + 1 >= array_space_reserved){
            array_space_reserved *= 2;
            array_data = realloc(array_data, sizeof(int) * array_space_reserved);
        }

        // get number from input and store it
        scanf("%d", array_data + array_space_used);
        array_space_used++;
    }

    // Init recursive call
    node solution = recursive_search(array_data, 0, array_space_used - 1);

    // Output
    printf("%d %d %d", solution.buy_point * 100, solution.sell_point * 100, solution.gain);
}