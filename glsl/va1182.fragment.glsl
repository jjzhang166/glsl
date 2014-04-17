// Scroller test by Optimus
//
// My thought was a simple way to draw fonts.
// Where there are pixel blocks now, I'd like to do with half or quarter circles more curvy stuff.
// I started with blocks. Problem is, I just realized that a glsl array needs a constant index value.
// I wanted in the draw font loop to do the y loop at least and also use font_number as an index to point to my array of fonts.
// But now one has to rewrite these fifteen single lines with different const numbers for each font because of constant index requirement :P
//
// So I stop here and maybe I'll think of something else (my original intend was to do a scroller with nice procedural fonts in a single glsl shader :)
//
// Update : Ok, there is still a way. Still copying a lot of the same stuff and making the shader eat memory.
// You can't have all IF letters without memory full, so choose carefully your text

// Update 2 : Making some fonts more curvy

#ifdef GL_ES
precision mediump float;
#endif

#define _O 15.;
#define _P 16.;
#define _T 20.; 
//...etc. tiny fork by @danbri to see if define macros could work...?
// or... could http://damieng.com/blog/2011/02/20/typography-in-8-bits-system-fonts fit in memory?

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float screen_ratio = resolution.y / resolution.x;

const float font_width = 3.0;
const float font_height = 5.0;
const float fonts_number = 2.0;

const float text_length = 16.0;
float text[int(text_length)];

vec3 font_spc[int(font_height)]; // 0
vec3 font_a[int(font_height)];	// 1
vec3 font_b[int(font_height)];	// 2
vec3 font_c[int(font_height)];	// 3
vec3 font_d[int(font_height)];	// 4
vec3 font_e[int(font_height)];	// 5
vec3 font_f[int(font_height)];	// 6
vec3 font_g[int(font_height)];	// 7
vec3 font_h[int(font_height)];	// 8
vec3 font_i[int(font_height)];	// 9
vec3 font_j[int(font_height)];	// 10
vec3 font_k[int(font_height)];	// 11
vec3 font_l[int(font_height)];	// 12
vec3 font_m[int(font_height)];	// 13
vec3 font_n[int(font_height)];	// 14
vec3 font_o[int(font_height)];	// 15
vec3 font_p[int(font_height)];	// 16
vec3 font_q[int(font_height)];	// 17
vec3 font_r[int(font_height)];	// 18
vec3 font_s[int(font_height)];	// 19
vec3 font_t[int(font_height)];	// 20
vec3 font_u[int(font_height)];	// 21
vec3 font_v[int(font_height)];	// 22
vec3 font_w[int(font_height)];	// 23
vec3 font_x[int(font_height)];	// 24
vec3 font_y[int(font_height)];	// 25
vec3 font_z[int(font_height)];	// 26

void init_text()
{
	text[0] = _O;
	text[1] = _P;
	text[2] = _T;
	text[3] = 9.0;
	text[4] = 13.0;
	text[5] = 21.0;
	text[6] = 19.0;
	text[7] = 0.0;
	text[8] = 23.0;
	text[9] = 1.0;
	text[10] = 19.0;
	text[11] = 0.0;
	text[12] = 8.0;
	text[13] = 5.0;
	text[14] = 18.0;
	text[15] = 5.0;
}

void init_fonts()
{
	font_spc[0] = vec3(0.0, 0.0, 0.0);
	font_spc[1] = vec3(0.0, 0.0, 0.0);
	font_spc[2] = vec3(0.0, 0.0, 0.0);
	font_spc[3] = vec3(0.0, 0.0, 0.0);
	font_spc[4] = vec3(0.0, 0.0, 0.0);

	font_a[0] = vec3(0.1, 1.0, 0.2);
	font_a[1] = vec3(1.0, 0.9, 1.0);
	font_a[2] = vec3(1.0, 1.0, 1.0);
	font_a[3] = vec3(1.0, 0.5, 1.0);
	font_a[4] = vec3(1.0, 0.0, 1.0);

	font_b[0] = vec3(1.0, 1.0, 0.0);
	font_b[1] = vec3(1.0, 0.0, 1.0);
	font_b[2] = vec3(1.0, 1.0, 1.0);
	font_b[3] = vec3(1.0, 0.0, 1.0);
	font_b[4] = vec3(1.0, 1.0, 0.0);

	font_c[0] = vec3(0.0, 1.0, 0.0);
	font_c[1] = vec3(1.0, 0.0, 1.0);
	font_c[2] = vec3(1.0, 0.0, 0.0);
	font_c[3] = vec3(1.0, 0.0, 1.0);
	font_c[4] = vec3(0.0, 1.0, 0.0);
	
	font_d[0] = vec3(1.0, 1.0, 0.0);
	font_d[1] = vec3(1.0, 0.0, 1.0);
	font_d[2] = vec3(1.0, 0.0, 1.0);
	font_d[3] = vec3(1.0, 0.0, 1.0);
	font_d[4] = vec3(1.0, 1.0, 0.0);
	
	font_e[0] = vec3(1.0, 1.0, 1.0);
	font_e[1] = vec3(1.0, 0.7, 0.0);
	font_e[2] = vec3(1.0, 1.0, 0.0);
	font_e[3] = vec3(1.0, 0.7, 0.0);
	font_e[4] = vec3(1.0, 1.0, 1.0);
	
	font_f[0] = vec3(1.0, 1.0, 1.0);
	font_f[1] = vec3(1.0, 0.0, 0.0);
	font_f[2] = vec3(1.0, 1.0, 0.0);
	font_f[3] = vec3(1.0, 0.0, 0.0);
	font_f[4] = vec3(1.0, 0.0, 0.0);
	
	font_g[0] = vec3(0.0, 1.0, 0.0);
	font_g[1] = vec3(1.0, 0.0, 1.0);
	font_g[2] = vec3(1.0, 0.0, 0.0);
	font_g[3] = vec3(1.0, 0.0, 1.0);
	font_g[4] = vec3(0.0, 1.0, 1.0);
	
	font_h[0] = vec3(1.0, 0.0, 1.0);
	font_h[1] = vec3(1.0, 0.0, 1.0);
	font_h[2] = vec3(1.0, 1.0, 1.0);
	font_h[3] = vec3(1.0, 0.0, 1.0);
	font_h[4] = vec3(1.0, 0.0, 1.0);

  	font_i[0] = vec3(0.0, 1.0, 0.0);
	font_i[1] = vec3(0.0, 1.0, 0.0);
	font_i[2] = vec3(0.0, 1.0, 0.0);
	font_i[3] = vec3(0.0, 1.0, 0.0);
	font_i[4] = vec3(0.0, 1.0, 0.0);

  	font_j[0] = vec3(0.0, 0.0, 1.0);
	font_j[1] = vec3(0.0, 0.0, 1.0);
	font_j[2] = vec3(0.0, 0.0, 1.0);
	font_j[3] = vec3(1.0, 0.0, 1.0);
	font_j[4] = vec3(0.0, 1.0, 0.0);
	
	font_k[0] = vec3(1.0, 0.0, 1.0);
	font_k[1] = vec3(1.0, 0.0, 1.0);
	font_k[2] = vec3(1.0, 1.0, 0.0);
	font_k[3] = vec3(1.0, 0.0, 1.0);
	font_k[4] = vec3(1.0, 0.0, 1.0);
	
	font_l[0] = vec3(1.0, 0.0, 0.0);
	font_l[1] = vec3(1.0, 0.0, 0.0);
	font_l[2] = vec3(1.0, 0.0, 0.0);
	font_l[3] = vec3(1.0, 0.0, 0.0);
	font_l[4] = vec3(1.0, 1.0, 1.0);
	
	font_m[0] = vec3(0.2, 0.6, 0.1);
	font_m[1] = vec3(1.0, 1.0, 1.0);
	font_m[2] = vec3(1.0, 0.0, 1.0);
	font_m[3] = vec3(1.0, 0.0, 1.0);
	font_m[4] = vec3(1.0, 0.0, 1.0);

	font_n[0] = vec3(1.0, 0.0, 0.0);
	font_n[1] = vec3(1.0, 1.0, 0.0);
	font_n[2] = vec3(1.0, 0.0, 1.0);
	font_n[3] = vec3(1.0, 0.0, 1.0);
	font_n[4] = vec3(1.0, 0.0, 1.0);
	
  	font_o[0] = vec3(0.1, 1.0, 0.2);
	font_o[1] = vec3(1.0, 0.5, 1.0);
	font_o[2] = vec3(1.0, 0.0, 1.0);
	font_o[3] = vec3(1.0, 0.6, 1.0);
	font_o[4] = vec3(0.4, 1.0, 0.3);
	
	font_p[0] = vec3(1.0, 1.0, 0.2);
	font_p[1] = vec3(1.0, 0.9, 1.0);
	font_p[2] = vec3(1.0, 1.0, 0.3);
	font_p[3] = vec3(1.0, 0.0, 0.0);
	font_p[4] = vec3(1.0, 0.0, 0.0);

  	font_q[0] = vec3(0.0, 1.0, 0.0);
	font_q[1] = vec3(1.0, 0.0, 1.0);
	font_q[2] = vec3(1.0, 0.0, 1.0);
	font_q[3] = vec3(1.0, 1.0, 0.0);
	font_q[4] = vec3(0.0, 0.0, 1.0);
	
	font_r[0] = vec3(1.0, 1.0, 0.2);
	font_r[1] = vec3(1.0, 0.9, 0.3);
	font_r[2] = vec3(1.0, 1.0, 0.7);
	font_r[3] = vec3(1.0, 0.5, 0.2);
	font_r[4] = vec3(1.0, 0.0, 1.0);
	
	font_s[0] = vec3(0.1, 1.0, 1.0);
	font_s[1] = vec3(1.0, 0.7, 0.0);
	font_s[2] = vec3(1.0, 1.0, 1.0);
	font_s[3] = vec3(0.0, 0.8, 1.0);
	font_s[4] = vec3(1.0, 1.0, 0.3);
	
	font_t[0] = vec3(1.0, 1.0, 1.0);
	font_t[1] = vec3(0.0, 1.0, 0.0);
	font_t[2] = vec3(0.0, 1.0, 0.0);
	font_t[3] = vec3(0.0, 1.0, 0.0);
	font_t[4] = vec3(0.0, 1.0, 0.0);
	
	font_u[0] = vec3(1.0, 0.0, 1.0);
	font_u[1] = vec3(1.0, 0.0, 1.0);
	font_u[2] = vec3(1.0, 0.0, 1.0);
	font_u[3] = vec3(1.0, 0.6, 1.0);
	font_u[4] = vec3(0.4, 1.0, 0.3);

	font_v[0] = vec3(1.0, 0.0, 1.0);
	font_v[1] = vec3(1.0, 0.0, 1.0);
	font_v[2] = vec3(1.0, 0.0, 1.0);
	font_v[3] = vec3(1.0, 0.0, 1.0);
	font_v[4] = vec3(0.0, 1.0, 0.0);
	
	font_w[0] = vec3(1.0, 0.0, 1.0);
	font_w[1] = vec3(1.0, 0.0, 1.0);
	font_w[2] = vec3(1.0, 0.0, 1.0);
	font_w[3] = vec3(1.0, 1.0, 1.0);
	font_w[4] = vec3(1.0, 0.5, 1.0);
	
	font_x[0] = vec3(1.0, 0.0, 1.0);
	font_x[1] = vec3(1.0, 0.0, 1.0);
	font_x[2] = vec3(0.0, 1.0, 0.0);
	font_x[3] = vec3(1.0, 0.0, 1.0);
	font_x[4] = vec3(1.0, 0.0, 1.0);

	font_y[0] = vec3(1.0, 0.0, 1.0);
	font_y[1] = vec3(1.0, 0.0, 1.0);
	font_y[2] = vec3(0.0, 1.0, 0.0);
	font_y[3] = vec3(0.0, 1.0, 0.0);
	font_y[4] = vec3(0.0, 1.0, 0.0);
	
	font_z[0] = vec3(1.0, 1.0, 1.0);
	font_z[1] = vec3(0.0, 0.0, 1.0);
	font_z[2] = vec3(0.0, 1.0, 0.0);
	font_z[3] = vec3(1.0, 0.0, 0.0);
	font_z[4] = vec3(1.0, 1.0, 1.0);
}

float draw_font_block(vec2 pixel_position, vec2 font_position, vec2 size, float tile_type)
{
	float gradient = 0.0;

	vec2 centered_font_position = font_position;

	if (abs(pixel_position.x - centered_font_position.x) <= size.x / 2.0 && 
	    abs(pixel_position.y - centered_font_position.y) <= size.y / 2.0)
	{
		if (tile_type==0.0 || tile_type==1.0)
		{
			gradient = tile_type;
		}
		else if (tile_type==0.1)
		{
			gradient = floor(2.58 - length(pixel_position - centered_font_position + vec2(-0.01, 0.01)) * 64.0);
		}
		else if (tile_type==0.2)
		{
			gradient = floor(2.58 - length(pixel_position - centered_font_position + vec2(0.01, 0.01)) * 64.0);
		}
		else if (tile_type==0.3)
		{
			gradient = floor(2.58 - length(pixel_position - centered_font_position + vec2(0.01, -0.01)) * 64.0);
		}
		else if (tile_type==0.4)
		{
			gradient = floor(2.58 - length(pixel_position - centered_font_position + vec2(-0.01, -0.01)) * 64.0);
		}
		else if (tile_type==0.5)
		{
			gradient = floor(length(pixel_position - centered_font_position) * 64.0);
			if (pixel_position.y <= centered_font_position.y) gradient = 0.0;
		}
		else if (tile_type==0.6)
		{
			gradient = floor(length(pixel_position - centered_font_position) * 64.0);
			if (pixel_position.y >= centered_font_position.y) gradient = 0.0;
		}
		else if (tile_type==0.7)
		{
			gradient = floor(length(pixel_position - centered_font_position) * 64.0);
			if (pixel_position.x >= centered_font_position.x) gradient = 0.0;
		}
		else if (tile_type==0.8)
		{
			gradient = floor(length(pixel_position - centered_font_position) * 64.0);
			if (pixel_position.x <= centered_font_position.x) gradient = 0.0;
		}
		else if (tile_type==0.9)
		{
			gradient = floor(length(pixel_position - centered_font_position) * 64.0);
		}

		if (gradient > 1.0) gradient = 1.0;
	}

	return gradient;
}

float draw_font_render(vec2 pixel_position, vec2 font_position, vec2 size, vec3 fontdata[5])
{
	float gradient = 0.0;
	font_position = (font_position - vec2(size.x * font_width, size.y * font_height) / 2.0) * vec2(1.0, screen_ratio);

//	for (float y=0.0; y<font_height; y++)
//	{
//		for (float x=0.0; x<font_width; x++)
//		{
			gradient += draw_font_block(pixel_position, font_position + size * vec2(0.0, 4.0), size, fontdata[0].x);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(1.0, 4.0), size, fontdata[0].y);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(2.0, 4.0), size, fontdata[0].z);

			gradient += draw_font_block(pixel_position, font_position + size * vec2(0.0, 3.0), size, fontdata[1].x);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(1.0, 3.0), size, fontdata[1].y);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(2.0, 3.0), size, fontdata[1].z);

			gradient += draw_font_block(pixel_position, font_position + size * vec2(0.0, 2.0), size, fontdata[2].x);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(1.0, 2.0), size, fontdata[2].y);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(2.0, 2.0), size, fontdata[2].z);

			gradient += draw_font_block(pixel_position, font_position + size * vec2(0.0, 1.0), size, fontdata[3].x);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(1.0, 1.0), size, fontdata[3].y);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(2.0, 1.0), size, fontdata[3].z);

			gradient += draw_font_block(pixel_position, font_position + size * vec2(0.0, 0.0), size, fontdata[4].x);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(1.0, 0.0), size, fontdata[4].y);
			gradient += draw_font_block(pixel_position, font_position + size * vec2(2.0, 0.0), size, fontdata[4].z);
//		}
//	}

	return gradient;
}

float draw_font(vec2 pixel_position, vec2 font_position, vec2 size, float font_number)
{
	float gradient = 0.0;

	if (font_number==0.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_spc);
	}
	else if (font_number==1.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_a);
	}
/*	else if (font_number==2.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_b);
	}
	else if (font_number==3.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_c);
	}
	else if (font_number==4.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_d);
	}*/
	else if (font_number==5.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_e);
	}
/*	else if (font_number==6.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_f);
	}
	else if (font_number==7.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_g);
	}*/
	else if (font_number==8.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_h);
	}
	else if (font_number==9.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_i);
	}
/*	else if (font_number==10.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_j);
	}
	else if (font_number==11.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_k);
	}
	else if (font_number==12.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_l);
	}*/
	else if (font_number==13.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_m);
	}
/*	else if (font_number==14.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_n);
	}*/
	else if (font_number==15.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_o);
	}
	else if (font_number==16.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_p);
	}
/*	else if (font_number==17.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_q);
	}*/
	else if (font_number==18.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_r);
	}
	else if (font_number==19.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_s);
	}
	else if (font_number==20.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_t);
	}
	else if (font_number==21.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_u);
	}
/*	else if (font_number==22.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_v);
	}*/
	else if (font_number==23.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_w);
	}
/*	else if (font_number==24.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_x);
	}
	else if (font_number==25.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_y);
	}
	else if (font_number==26.0)
	{
		gradient = draw_font_render(pixel_position, font_position, size, font_z);
	}*/


	return gradient;
}

float draw_text(vec2 pixel_position, vec2 font_position, vec2 size)
{
	float gradient = 0.0;
	float font_size = size.x * (font_width + 1.0);

	gradient += draw_font(pixel_position, font_position + vec2(0.0, 0.0) * font_size, size, text[0]);
	gradient += draw_font(pixel_position, font_position + vec2(1.0, 0.0) * font_size, size, text[1]);
	gradient += draw_font(pixel_position, font_position + vec2(2.0, 0.0) * font_size, size, text[2]);
	gradient += draw_font(pixel_position, font_position + vec2(3.0, 0.0) * font_size, size, text[3]);
	gradient += draw_font(pixel_position, font_position + vec2(4.0, 0.0) * font_size, size, text[4]);
	gradient += draw_font(pixel_position, font_position + vec2(5.0, 0.0) * font_size, size, text[5]);
	gradient += draw_font(pixel_position, font_position + vec2(6.0, 0.0) * font_size, size, text[6]);
	gradient += draw_font(pixel_position, font_position + vec2(7.0, 0.0) * font_size, size, text[7]);
	gradient += draw_font(pixel_position, font_position + vec2(8.0, 0.0) * font_size, size, text[8]);
	gradient += draw_font(pixel_position, font_position + vec2(9.0, 0.0) * font_size, size, text[9]);
	gradient += draw_font(pixel_position, font_position + vec2(10.0, 0.0) * font_size, size, text[10]);
	gradient += draw_font(pixel_position, font_position + vec2(11.0, 0.0) * font_size, size, text[11]);
	gradient += draw_font(pixel_position, font_position + vec2(12.0, 0.0) * font_size, size, text[12]);
	gradient += draw_font(pixel_position, font_position + vec2(13.0, 0.0) * font_size, size, text[13]);
	gradient += draw_font(pixel_position, font_position + vec2(14.0, 0.0) * font_size, size, text[14]);
	gradient += draw_font(pixel_position, font_position + vec2(15.0, 0.0) * font_size, size, text[15]);

	return gradient;
}

void main( void ) {

	init_fonts();
	init_text();

	float zoom = 0.03;// + sin(time) * 0.029;
	float sx = zoom;
	float sy = zoom;

	vec2 pixel_position = vec2(gl_FragCoord.x / resolution.x, gl_FragCoord.y / resolution.x);

	float fx = 0.2;
	float fy = 0.5;
	float dispx = 1.0 - mod(0.3 * time, text_length * (font_width + 1.0) * sx + 1.5);
	float dispy = sin(pixel_position.x * 16.0 + 0.5 * time) * 0.025 + sin(pixel_position.x * 48.0 + 1.5 * time) * 0.0125;

	vec2 font_position = (vec2(fx, fy) + vec2(dispx, dispy));
	vec2 font_size = vec2(sx, sy);

	float gradient = draw_text(pixel_position, font_position, font_size);

	float r = 0.2 + sin(time * 2.2);
	float g = 0.3 + sin(time * 1.5);
	float b = 0.7 + sin(time + pixel_position.y * 32.0);
	vec4 font_color = vec4(vec3(r,g,b) * gradient, 1.0);	//vec3(gradient * sin(pixel_position.y * 300.0 + 16.0 * time), gradient * sin(pixel_position.y * 200.0 + 32.0 * time), gradient * sin(pixel_position.y * 100.0 + 28.0 * time)), 1.0);
	vec4 background_color = vec4(vec3(abs(pixel_position.y - 0.5 * screen_ratio)) * 4.0, 1.0);

	gl_FragColor = mix(background_color, font_color, 0.5);

}