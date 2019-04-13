load lab02_data.csv
input_dataata = lab02_data(:,1:3);
output_data = lab02_data(:,4);

number_of_clusters = 3;
 [cluster_centers, soft_partition, obj_fcn_history] = ...
   fcm (input_data, number_of_clusters)
 
 ## Plot the data points as small blue x's.
 figure ('NumberTitle', 'off', 'Name', 'FCM Demo 1');
 for i = 1 : rows (input_data)
   plot (input_data(i, 1), input_data(i, 2), 'LineWidth', 2, ...
         'marker', 'x', 'color', 'b');
   hold on;
 endfor

 ## Plot the cluster centers as larger red *'s.
 for i = 1 : number_of_clusters
   plot (cluster_centers(i, 1), cluster_centers(i, 2), ...
         'LineWidth', 4, 'marker', '*', 'color', 'r');
   hold on;
 endfor

 ## Make the figure look a little better:
 ##    - scale and label the axes
 ##    - show gridlines
 xlim ([0 15]);
 ylim ([0 15]);
 xlabel ('Feature 1');
 ylabel ('Feature 2');
 grid
 hold
 
 ## Calculate and print the three validity measures.
 printf ("Partition Coefficient: %f\n", ...
         partition_coeff (soft_partition));
 printf ("Partition Entropy (with a = 2): %f\n", ...
         partition_entropy (soft_partition, 2));
 printf ("Xie-Beni Index: %f\n\n", ...
         xie_beni_index (input_data, cluster_centers, ...
         soft_partition));