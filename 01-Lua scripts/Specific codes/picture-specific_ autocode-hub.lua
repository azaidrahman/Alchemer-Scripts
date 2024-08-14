image_html = '<img alt="@@ALT@@" src="https://surveygizmolibrary.s3.amazonaws.com/library/642038/@@PIC@@.png" style="border-width: 1px; border-style: solid; width: 800px;" />'

placeholder_pic = '@@PIC@@'
placeholder_alt = '@@ALT@@'
placeholder_name = '@@NAME@@'
placeholder_desc = '@@DESC@@'

names = {
    'IMMUNITY','ENERGILITY','VITALITY','INTELIGIBILITY','SUSTAINABILITY'
}

name_html = '<strong>@@NAME@@</strong>'
desc_html = '<br /><em>@@DESC@@</em><br />'
descs = {
    {[[Focused on strengthening or boosting the immune system with natural ingredients such as ginger, turmeric, and lemon. A sustainable, healthy shot to kickstart your day, while contributing to the normal function of the immune system.]],

    [[Focused on giving you energy boosts by using natural ingredients such as ginseng, guarana, and moringa. A shot to bring energy back, for the day or task ahead of you.]],

    [[Focused to restore and enhance your healthy glow and bouncy skin with natural ingredients such as berries, ginger, aloe and gingko. A shot to revive your beauty.]],

    [[Focused on balancing and helping to unwind the body and mind with natural ingredients such as moringa, gingko, lavender, and chamomile. A shot to bring clarity and calm, especially during a busy day.]],

    [[Focused on giving you balance and meeting your body’s necessary needs by using natural ingredients such as spinach, beets, oranges, mangoes, and berries. A daily shot that gives super foods to your body for daily maintenance.]]
    },
    
    {[[Fokus pada menguatkan atau meningkatkan sistem imun dengan bahan-bahan semula jadi seperti halia, kunyit, dan limau. Minuman harian tetap yang sihat untuk memulakan hari anda sambil mengekalkan sistem imun yang baik.]],
    [[Fokus untuk memberi rangsangan tenaga dengan bahan-bahan semula jadi seperti ginseng, guarana dan moringa. Minuman untuk mengembalikan tenaga bagi melengkapkan tugasan seharian.]],
    [[Fokus untuk mengembalikan dan meningkatkan seri muka dan keanjalan kulit anda dengan bahan-bahan semula jadi seperti buah beri, halia, aloe dan gingko. Minuman yang menambah baik kecantikan semula jadi anda.]],
    [[Fokus pada keseimbangan diri dan membantu untuk merehatkan badan dan minda dengan bahan-bahan semula jadi seperti moringa, gingko, lavender, dan chamomile. Minuman yang membawa kejelasan dan ketenangan fikiran, terutamanya pada hari yang sibuk.]],
    [[Fokus pada memberi anda keseimbangan dan memenuhi keperluan badan anda dengan menggunakan bahan-bahan semula jadi seperti bayam, bit, oren, mangga, dan buah beri. Minuman yang memberikan sumber nutrisi kepada badan anda untuk penyelenggaraan harian.]],
    },
    
    {[[专注于增强免疫系统，采用生姜、姜黄和柠檬等天然成分。以健康而且可持续性的方式，开启新的一天，并维持健康的免疫系统。]],
    [[专注于提供能量和精力，通过使用人参、瓜拉那(Guarana) 和辣木 (moringa)等天然成分。提供能量，以应付每一天的任务。]],
    [[专注于恢复和增强您的健康光泽和弹性肌肤，采用莓果、生姜、芦荟和银杏等天然成分，让您美丽重现。]],
    [[专注于平衡和放松心情，采用辣木(Moringa) 、银杏 、薰衣草和洋甘菊等天然成分。带来清晰和平静的身心，尤其是在忙碌的一天。]],
    [[专注于为您提供平衡并满足身体必要的营养需求，使用菠菜、甜菜、橙子、芒果和莓果等天然成分。每日饮用以为您提供超级食物成分，让身体进行日常修护。]],
    }
}

language = tonumber(getvalue(68))
language_tbl = {
    '',
    '_MY',
    '_CN'
}
name_id = {394,395,396,397,398}
desc_id = {399,400,401,402,403}
autocode_id = {
    {383,388},{384,389},{385,390},{386,391},{387,392}
}

function main()
    --insert the other databases into autocode base
    for i,arr in pairs(autocode_id) do
        table.insert(arr,name_id[i])
        table.insert(arr,desc_id[i])
    end

    --shuffle the order of concepts
    shuffle(autocode_id)

    
    for lang_i,lang_suffix in pairs(language_tbl) do
        if lang_i == language then
            for i,name in pairs(names) do
                local concept_index, picture_index, name_index, desc_index = autocode_id[i][1],autocode_id[i][2],autocode_id[i][3],autocode_id[i][4]
                local final_image = image_html:gsub(placeholder_alt,name..'_ '..i)
                final_image = final_image:gsub(placeholder_pic,name..lang_suffix)
                
                setvalue(concept_index,i)
                setvalue(picture_index,final_image)
                setvalue(name_index,name_html:gsub(placeholder_name,name))
                setvalue(desc_index,desc_html:gsub(placeholder_desc,descs[language][i]))

            end
        end
    end
end

function shuffle(tbl)
    local n = #tbl  -- Get the size of the table
    for i = n, 2, -1 do  -- Iterate from the last element to the second
      local j = math.random(i)  -- Generate a random index between 1 and i
      tbl[i], tbl[j] = tbl[j], tbl[i]  -- Swap the elements at i and j
    end
    return tbl  -- Return the shuffled table
  end
  
main()



