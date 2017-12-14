#!/bin/sh
MUSER="$1"
MPASS="$2"
MDB="$3"
DUMPFILE="$4"
MHOST="localhost"
[ "$5" != "" ] && MHOST="$5"

echo "/*Database '$MDB' from '$MHOST' dumped on $(date) */;" > $DUMPFILE

###
# network wide settings
###
# get s3 plugin settings
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_sitemeta --where="meta_key = 'tantan_wordpress_s3'" --no-create-info --no-tablespaces --replace --skip-comments >> $DUMPFILE

# get GA dashboard plugin settings
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_sitemeta --where="meta_key = 'gadash_network_options'" --no-create-info --no-tablespaces --replace --skip-comments >> $DUMPFILE

###
# site wide settings
###
# get all content
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_posts --skip-comments >> $DUMPFILE
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_2_posts --skip-comments >> $DUMPFILE

# get additional post information and menues
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_postmeta wp_terms wp_termmeta wp_term_taxonomy wp_term_relationships --skip-comments >> $DUMPFILE
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_2_postmeta wp_2_terms wp_2_termmeta wp_2_term_taxonomy wp_2_term_relationships --skip-comments >> $DUMPFILE

# get customization settings of the theme
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_options --where="option_name = 'theme_mods_project-wp-theme'" --no-create-info --no-tablespaces --replace --skip-comments >> $DUMPFILE
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_2_options --where="option_name = 'theme_mods_project-wp-theme'" --no-create-info --no-tablespaces --replace --skip-comments >> $DUMPFILE

# get pageid for home page
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_options --where="option_name = 'page_on_front'" --no-create-info --no-tablespaces --replace --skip-comments >> $DUMPFILE
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_2_options --where="option_name = 'page_on_front'" --no-create-info --no-tablespaces --replace --skip-comments >> $DUMPFILE

# make sure the schema of the tables for the redirection plugin exist
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_redirection_404 wp_redirection_groups wp_redirection_items wp_redirection_logs --no-data --skip-comments >> $DUMPFILE
mysqldump -u $MUSER --password=$MPASS -h $MHOST $MDB wp_2_redirection_404 wp_2_redirection_groups wp_2_redirection_items wp_2_redirection_logs --no-data --skip-comments >> $DUMPFILE
