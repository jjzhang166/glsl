// Text tutorial - by @h3r3 (you can find me on Twitter)
// This is a very simple (and not fast) way to write vectorial text in a shader.
// As I was request to write some comments on how it works I wrote this small tutorial.
//
// Have fun :)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

// Returns true if coordinate pos is contained in the rectangle between upperLeft and lowerRight
bool rect(in vec2 pos, in vec2 upperLeft, in vec2 lowerRight) {
	return pos.x > upperLeft.x && pos.y > upperLeft.y && pos.x < lowerRight.x && pos.y < lowerRight.y;
}

// Returns true if coordinate pos is inside triangle with vertices a, b, c
bool tria(in vec2 pos, in vec2 a, in vec2 b, in vec2 c) {
	vec2 v0 = c - a, v1 = b - a, v2 = pos - a;
	float dot00 = dot(v0, v0), dot01 = dot(v0, v1), dot02 = dot(v0, v2), dot11 = dot(v1, v1), dot12 = dot(v1, v2);
	float invDenom = 1. / (dot00 * dot11 - dot01 * dot01);
	float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
	float v = (dot00 * dot12 - dot01 * dot02) * invDenom;
	return (u >= .0) && (v >= .0) && (u + v < 1.);
}

// Returns true if pos is inside character "h" with lower left corner positioned at 0,0 and maximum size 1.0 x 1.0
bool letterH(in vec2 pos) {
	return pos.x>.0 && pos.x<.6 && pos.y>.0 && pos.y<1.  // First line just checks the bounding rectangle, should improve performance
		&& rect(pos, vec2(.0), vec2(.2,1.))          // && can be used for intersection of shapes, || can be used for union of shapes
		|| rect(pos, vec2(.2,.4), vec2(.4,.6))
		|| rect(pos, vec2(.4,.0), vec2(.6,.5))
		|| tria(pos, vec2(.4,.5), vec2(.6,.5), vec2(.4,.6));
}

bool letter3(in vec2 pos) {
	return pos.x>.0 && pos.x<.6 && pos.y>.0 && pos.y<1.
		&& rect(pos, vec2(.0), vec2(.4, .2))
		|| rect(pos, vec2(.0,.8), vec2(.4, 1.))
		|| rect(pos, vec2(.2,.4), vec2(.4,.6))
		|| (pos.x <.6
		    && tria(pos, vec2(.4,.0), vec2(.4,1.), vec2(1.4,.5))
		    && !tria(pos, vec2(.6,.6), vec2(.6,.4), vec2(.5,.5))); // ! can be used for subtraction of shapes
}

bool letterR(in vec2 pos) {
	return pos.x>.0 && pos.x<.6 && pos.y>.0 && pos.y<1.
		&& rect(pos, vec2(.0), vec2(.2, 1.))
		|| (pos.x > .2
		    && pos.x < .6
		    && tria(pos, vec2(-.2,.6), vec2(.4,.9), vec2(1.,.6))
		    && !tria(pos, vec2(.2,.6), vec2(.4,.7), vec2(.6,.6)));
}

void main()
{
	vec3 color;
	vec2 p = vec2(gl_FragCoord.x - resolution.x/2., gl_FragCoord.y - resolution.y/2.) / resolution.y;
	
	// At this point p has resolution independent screen coordinates, in range -0.5 .. 0.5 (x is left to right, y is bottom to top)
	
	// maximum size of each letter is 1.0 x 1.0 and they have their lower left corner in (0,0)
	
	// I decided not to apply geometric transformations to the characters themselves but instead to transform the coordinates passed to the functions that draw them (the p variable)
	// Then "p" must be modified using the opposite transformation we would apply directly to the character.
	
	// Example 1: if you want to reduce a character size by half you have to multiply the screen coordinates by 2
	//p *= 2.; // Uncomment to test
	
	// Example 2: if you want to translate left you have to increase p.x
	//p.x += 1.5; // Uncomment to test
	
	// Example 3: you can use the time variable and sin or cos to add simple animations
	//p.y += sin(time * 1.5) * 0.3; // Uncomment to test, here 1.5 is the speed and 0.3 is the length of the oscillation
	
	
	// Now we write the "h" character with our modified p
	if (letterH(p)) color += 1.0; // 1.0 is for total opacity
	
	// Or you can write the "3" character with slightly on the right, with half opacity: 0.5
	//if (letter3(vec2(p.x - 0.8, p.y))) color += 0.5; // Uncomment to test, - 0.8 is translation to the right and 0.5 is half opacity
	
	// Or you can write a colorored "r"
	//if (letterR(vec2(p.x - 1.6, p.y))) color += vec3(1.0, 0.5, 0.3); // Uncomment to test, 1.0 is red component, 0.5 is green component, 0.3 is blue component
	
	// Remember that you can compose different transformations
	//if (letter3(vec2(p.x - 2.4 + cos(time) * 0.1, p.y))) color += vec3(1.0, 0.5, 0.3) * .5; // Uncomment to test
	
	// And you can use for loops :) ... this is left to the reader
	
	
	gl_FragColor = vec4(color, 1.0);
}