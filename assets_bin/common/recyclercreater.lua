import "androidx.appcompat.widget.AppCompatTextView"
import "androidx.appcompat.widget.AppCompatImageView"
import "androidx.appcompat.widget.AppCompatCheckBox"
import "androidx.appcompat.widget.SwitchCompat"
import "androidx.recyclerview.widget.RecyclerView"
import "androidx.recyclerview.widget.LinearLayoutManager"

function recyclerViewInit(mRecycler,itemlayout)
  local layoutManager = LinearLayoutManager(activity, RecyclerView.VERTICAL, false)

  local function LuaViewHolder(view)
    return luajava.override(RecyclerView.ViewHolder, {}, view)
  end

  -- 重写 RecyclerView.Adapter 的几个方法
  local MyAdapter = luajava.override(RecyclerView.Adapter,{
    getItemCount = function(super)
      return int(#list)
    end,
    getItemViewType = function(super, position)
      return int(list[position+1].type)
    end,
    onCreateViewHolder = function(super, parent, viewType)
      local views={}
      local holder=LuaViewHolder(loadlayout(itemlayout, views))
      holder.itemView.setTag(views)
      return holder
    end,
    onBindViewHolder = function(super, holder, position)
      -- 获取视图
      local view = holder.itemView.getTag()
      local v = list[position+1]

    end,
    onViewRecycled = function(super, holder)
      -- local view = holder.itemView.getTag()
    end,
  })

  mRecycler.setAdapter(MyAdapter).setLayoutManager(layoutManager)

end