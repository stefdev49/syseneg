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
  uint32_t maxwd;


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

  /* scan */
  resolution = 300;

   /* width in cm */
   lines = 400;
   pixels = (dev->sensor.sensor_pixels*resolution)/dev->sensor.optical_res;
   channels = 3;
   scanmode=SCAN_MODE_COLOR;
   depth=8;
   move=203;

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
   value |= REG32_GPIO13 | REG32_GPIO12 | REG32_GPIO11 | REG32_GPIO9;
   sanei_genesys_write_register (dev, REG32, value);
   */
   /*
   r = sanei_genesys_get_address (dev->reg, REG03);
   r->value = 0x50;
   r = sanei_genesys_get_address (dev->reg, REG04);
   r->value = 0x03;
   r = sanei_genesys_get_address (dev->reg, REG06);
   r->value = 0x50;*/
   /* no REG07 in set
   sanei_genesys_write_register (dev, 0x07, 0x00);
    * */
   /* removed from set after setup !!
   r = sanei_genesys_get_address (dev->reg, 0x0b);
   r->value = 0x2a;
   */
   /*
   r = sanei_genesys_get_address (dev->reg, 0x16);
   r->value = 0x11;
   sanei_genesys_write_register (dev, REG0B, 0x2a);
   r = sanei_genesys_get_address (dev->reg, 0x22);
   r->value=0x14;
*/
   /**
    * dump registers about to be sent to scanner in a format similar to those
    * from the usb log decoding scripts
    */
   // useless with debug messages dump_reg(dev->reg, GENESYS_GL124_MAX_REGS);
/*
   sanei_genesys_get_triple(dev->reg, REG_MAXWD, &maxwd);
   maxwd/=2;
   sanei_genesys_set_triple(dev->reg, REG_MAXWD, maxwd);
*/
   /*
   sanei_genesys_set_triple(dev->reg,REG_STRPIXEL,0);
   sanei_genesys_set_triple(dev->reg,REG_ENDPIXEL,0);
   */
   /* write registers to the scanner then start scan */
   RIE (sanei_genesys_bulk_write_register (dev, dev->reg, GENESYS_GL124_MAX_REGS));

   /* GPIO */
   /*
   sanei_genesys_write_register(dev, 0x31,0x9f);
   sanei_genesys_write_register(dev, 0x32,0x5b);
   sanei_genesys_write_register(dev, 0x33,0x01);
   sanei_genesys_write_register(dev, 0x34,0x80);
   sanei_genesys_write_register(dev, 0x35,0x5f);
   sanei_genesys_write_register(dev, 0x36,0x01);
   sanei_genesys_write_register(dev, 0x38,0x00);

   sanei_genesys_write_register(dev, 0x52,0x04);
   sanei_genesys_write_register(dev, 0x53,0x06);
   sanei_genesys_write_register(dev, 0x54,0x00);
   sanei_genesys_write_register(dev, 0x55,0x02);

   sanei_genesys_write_register(dev, 0x5a,0x3a);
   sanei_genesys_write_register(dev, 0x5c,0x00);
   sanei_genesys_write_register(dev, 0x5e,0x01);
   sanei_genesys_write_register(dev, 0x6d,0x00);
   sanei_genesys_write_register(dev, 0x70,0x1f);
   sanei_genesys_write_register(dev, 0x71,0x1f);
   sanei_genesys_write_register(dev, 0xc5,0x20);
   sanei_genesys_write_register(dev, 0xc6,0xeb);
   sanei_genesys_write_register(dev, 0xc7,0x20);
   sanei_genesys_write_register(dev, 0xc8,0xeb);
   sanei_genesys_write_register(dev, 0xc9,0x20);
   sanei_genesys_write_register(dev, 0xca,0xeb);
   sanei_genesys_write_register(dev, 0xcb,0x00);
   sanei_genesys_write_register(dev, 0xcc,0x00);
   sanei_genesys_write_register(dev, 0xcd,0x00);
   sanei_genesys_write_register(dev, 0xce,0x00);

   sanei_genesys_write_hregister(dev, 0x110,0x00);
   sanei_genesys_write_hregister(dev, 0x111,0x00);
   sanei_genesys_write_hregister(dev, 0x112,0x00);
   sanei_genesys_write_hregister(dev, 0x113,0x00);
   sanei_genesys_write_hregister(dev, 0x114,0x00);
   sanei_genesys_write_hregister(dev, 0x115,0x00);
*/
   /* start scan */
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
