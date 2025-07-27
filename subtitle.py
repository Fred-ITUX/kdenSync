import os
import re
from PIL import Image, ImageDraw, ImageFont


IMAGE_WIDTH     = 1920
IMAGE_HEIGHT    = 1080


#### Video
FONT_PATH       = "/home/federico/.fonts/Droid-sans/DroidSans-Bold.ttf"    



project = "oblivion"
part    = "Pt7"
subN    = "1"

OUTPUT_DIR = "/home/federico/Downloads"  
# OUTPUT_DIR = f"/home/federico/Videos/Edit/Projects/{project}/7-Parts/{part}/1-{project}_ROBBBA/sub{subN}"
#### Change setup for shorts
SHORTS = "n".lower().strip() #### "y" / "n"



#### Colors are RGBA

FONT_SIZE       = 200                   #### 200 for videos
TEXT_COLOR      = (255, 255, 255, 255)  #### standard white

# TEXT_COLOR      = (255, 20, 20, 255)  #### red



# colorChange = str(input("Sab s/f Fra : ")).lower().strip()
# # colorChange = "s".lower().strip()

# if colorChange == "s":
#     #### Sabaku
#     TEXT_COLOR      = (25, 225, 45, 255)   #### green
# elif colorChange == "f":
#     #### Frapollo
#     TEXT_COLOR      = (225, 229, 15, 255)  #### yellow




#### Offset for the shadow/outline effect
SHADOW_OFFSET   = (12, 12)            
SHADOW_COLOR    = (0, 0, 0, 255)    


#### Max length before splitting image 
maxLen          = 18

#### Max length for single words, less equal to
singleWordMaxLen = 11


#############################################################################


#### Different setup for shorts
if SHORTS == "y":
    ## print(f"Shorts: {SHORTS}")
    FONT_PATH       = "/home/federico/.fonts/Comic_Neue/ComicNeue-Bold.ttf"
    FONT_SIZE       = 350 
    
    SHADOW_OFFSET   = (16, 16)

    maxLen          = 10




#############################################################################


#### Cleans file names
def sanitize_filename(text):
    text = text.strip().replace(" ", "_")
    return re.sub(r"[^\w\-]", "", text)


#############################################################################



def create_image_with_text(text, output_filepath, font_size):
    # Create a new image with a transparent background
    image = Image.new("RGBA", (IMAGE_WIDTH, IMAGE_HEIGHT), (255, 255, 255, 0))
    draw = ImageDraw.Draw(image)
    
    try:
        font = ImageFont.truetype(FONT_PATH, font_size)
    except IOError:
        print(f"Could not load font at {FONT_PATH}. Please ensure the path is correct.")
        return


    #### Textbox
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    x = (IMAGE_WIDTH - text_width) // 2
    y = (IMAGE_HEIGHT - text_height) // 2



    #### Draw shadow/outline by drawing the text at multiple offset positions.
    shadow_positions = [
        (x + SHADOW_OFFSET[0], y + SHADOW_OFFSET[1]),
        (x - SHADOW_OFFSET[0], y - SHADOW_OFFSET[1]),
        (x + SHADOW_OFFSET[0], y - SHADOW_OFFSET[1]),
        (x - SHADOW_OFFSET[0], y + SHADOW_OFFSET[1])
    ]
    for pos in shadow_positions:
        draw.text(pos, text, font=font, fill=SHADOW_COLOR)

    #### Draw the main text on top of the shadow
    draw.text((x, y), text, font=font, fill=TEXT_COLOR)

    #### Save the image as a PNG (supports transparency)
    try:
        image.save(output_filepath)
        #print(f"Image saved as {output_filepath}")
    except Exception as e:
        print(f"Error saving image: {e}")



#############################################################################



def main():

    #### Output dir check
    if not os.path.exists(OUTPUT_DIR):
        try:
            os.makedirs(OUTPUT_DIR)
            print(f"Created directory: {OUTPUT_DIR}")
        except Exception as e:
            print(f"Error creating directory {OUTPUT_DIR}: {e}")
            return


    #### Keep track of what you are doing
    if SHORTS == "y":
        input_text = input(f"✅ Shorts MAX {maxLen}: ").strip()
    else: 
        input_text = input(f"❌ Shorts MAX {maxLen}: ").strip()
    

    if not input_text:
        print("No text entered. Exiting.")
        return


    #### Clear text to create filename
    base_filename = sanitize_filename(input_text)
    



    #### Single long word
    if len(input_text) > maxLen and len(input_text) <= singleWordMaxLen  and " " not in(input_text):
        output_file = os.path.join(OUTPUT_DIR, f"{base_filename}.png")
        create_image_with_text(input_text, output_file, FONT_SIZE)
        

    elif len(input_text) > maxLen:
        print(f"maxLen: {maxLen} | input len: {len(input_text)}")
        mid = len(input_text) // 2
        part1 = input_text[:mid].strip()
        part2 = input_text[mid:].strip()
        
        output_file1 = os.path.join(OUTPUT_DIR, f"{base_filename}_part1.png")
        output_file2 = os.path.join(OUTPUT_DIR, f"{base_filename}_part2.png")
        create_image_with_text(part1, output_file1, FONT_SIZE)
        create_image_with_text(part2, output_file2, FONT_SIZE)
        print(f"Created two images: '{output_file1}' and '{output_file2}'.")
    
    else:
        output_file = os.path.join(OUTPUT_DIR, f"{base_filename}.png")
        create_image_with_text(input_text, output_file, FONT_SIZE)
        #print(f"Created one image: '{output_file}'.")

if __name__ == "__main__":
    main()
