#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>

#undef BACKEND_NAME
#define BACKEND_NAME unit_testing

#include "sane/sane.h"
#include "sane/config.h"
#include "sane/sanei.h"
#include "sane/sanei_debug.h"
#include "sane/saneopts.h"

#include "sane/sanei_backend.h"
#include "sane/sanei_usb.h"
#include "sane/sanei_config.h"
#include "_stdint.h"
#include "sane/sane.h"
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <sys/time.h>


#define HACK
#include "genesys_gl124.h"

/**
 * Dumps register in a format similar to the one used by the USB log decoding scripts
 * @param reg register set to dump
 * @param size numbre of reisters in the set
 */
void dump_reg (Genesys_Register_Set * reg, int size)
{
  Genesys_Register_Set *r;
  int i;

  for (i = 1; i <= size; i++)
    {
      r = sanei_genesys_get_address (reg, i);
      if (r)
	{
	  printf ("registerWrite(0x%02x,0x%02x)\n", i, r->value);
	}
    }
}

int
main (int argc, char **argv)
{
  SANE_Int vc;
  SANE_Auth_Callback cb;
  SANE_Status status;
  Genesys_Settings settings;
  SANE_Handle handle;
  Genesys_Scanner *session;
  Genesys_Device *dev;
  unsigned size;
  unsigned int coeff, val, dk, br, target_bright, target_dark;
  int x, y, c, sum, startx, feed;
  unsigned int pixels_per_line, words_per_color;
  unsigned char *data = NULL, *buffer, *final, *black, *white, *shading;
  int pixels, lines, bpl, depth;
  int channels, resolution;
  Genesys_Register_Set *r;
  uint8_t value;
  float move, left;
  int move_dpi;
  int steps;
  int scanmode;
  struct timeval starttime;
  struct timeval endtime;
  char title[256];
   

  /* backend init */
  status = sane_genesys_init (&vc, cb);
  if (status != SANE_STATUS_GOOD)
    {
      printf ("sane_init()=%s\n", sane_strstatus (status));
      return 1;
    }
  status = sane_genesys_open ("genesys", &handle);
  if (status != SANE_STATUS_GOOD)
    {
      printf ("sane_open()=%s\n", sane_strstatus (status));
      sane_genesys_exit ();
      return 1;
    }

  session = (Genesys_Scanner *) handle;
  dev = session->dev;
 
  if(argc>1)
    {
     steps=atoi(argv[1]);
    }
  else
    {
     steps=256;
    } 
 
  status = gl124_feed(dev, 2000, SANE_FALSE);
  feed=10;

  /* scan */
  resolution = 600;
 
   /* width in cm */
   lines = 400;
   pixels = (dev->sensor.sensor_pixels*resolution)/dev->sensor.optical_res;
   channels = 1;
   scanmode=SCAN_MODE_COLOR;
   depth=8;
   move=feed;
 
   bpl = channels * pixels * (depth/8);
   status = gl124_init_scan_regs (dev,
                                  dev->reg,
                                  resolution,
                                  resolution,
                                  0.0,
                                  move,
                                  pixels,
                                  lines,
                                  depth,
                                  channels,
                                  SCAN_METHOD_FLATBED,
                                  scanmode,
                                  0,
                                  0);
   /* disable correction */
   r = sanei_genesys_get_address (dev->reg, REG01);
   r->value &= ~REG01_DVDSET;
   r = sanei_genesys_get_address (dev->reg, REG05);
   r->value &= ~REG05_GMMENB;
 
   /* override slope table */ 
   /* test(dev, steps); */
   
   size = lines * bpl;
 
   data = malloc (size);
   final = malloc (size);
   buffer = malloc (size);
   shading = malloc (bpl*2);
   black = malloc (bpl*2);
   white = malloc (bpl*2);
   if (!data || !final || !buffer || !shading || !white || !black)
     {
      return SANE_STATUS_NO_MEM;
     }

   /**
    * override registers value just before use to test their effect on the scan
    */
   /* 
   sanei_genesys_read_register (dev, REG32, &value);
   val |= REG32_GPIO13 | REG32_GPIO12 | REG32_GPIO11 | REG32_GPIO9;
   sanei_genesys_write_register (dev, REG32, value);
   */
   /**
    * dump registers about to be sent to scanner in a format similar to those
    * from the usb log decoding scripts
    */
   dump_reg(dev->reg, GENESYS_GL124_MAX_REGS);

   /* write registers to the scanner then start scan */
   RIE (sanei_genesys_bulk_write_register (dev, dev->reg, GENESYS_GL124_MAX_REGS));
   RIE (gl124_begin_scan(dev, dev->reg, SANE_TRUE));
   sanei_genesys_read_data_from_scanner (dev, data, size);
   RIE (gl124_end_scan (dev, dev->reg, SANE_TRUE));
   sprintf(title,"image-%d.pnm",steps);
   sanei_genesys_write_pnm_file (title, data, depth, channels, pixels, lines);
   printf("uncorrected picture written\n");


  printf("Parking ...\n");
  gettimeofday (&starttime, NULL);
  gl124_slow_back_home(dev, SANE_FALSE);
  sanei_genesys_wait_for_home(dev);
  gettimeofday (&endtime, NULL);
  printf("park time %ds\n",endtime.tv_sec-starttime.tv_sec);

  sane_genesys_close (handle);
  sane_genesys_exit ();
  printf("done\n");
  return 0;
}

/* vim: set sw=2 cino=>2se-1sn-1s{s^-1st0(0u0 smarttab expandtab: */
