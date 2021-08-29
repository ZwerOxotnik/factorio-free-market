local styles = data.raw["gui-style"].default

styles.fm_subheader_frame = {
  type = "frame_style",
  parent = "subheader_frame",
  height = 0, -- Negate the height requirement
  minimal_height = 36
}